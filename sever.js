const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');
const e = require('express');
const emailValidator = require('email-validator');


const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// Kết nối đến MongoDB
mongoose.connect('mongodb://localhost:27017/api');

// Định nghĩa schema cho người dùng
const userSchema = new mongoose.Schema({
  password: String,
  email: String,
  bag: [
    { product:{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product'
    },
    quantity: Number
  }]
});
// Tạo model từ schema
const User = mongoose.model('User', userSchema);

const productSchema = new mongoose.Schema({
  name: String,
  price: Number,
  detail: String,
  title: String,
  Image: String,
  thc: String,
  cbd: String,
})

const Product = mongoose.model('Product', productSchema);




// Endpoint đăng nhập
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body)
  try {
      const user = await User.findOne({ email, password });
    // Tìm người dùng trong MongoDB
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(401).json({ error: 'Invalid username or password' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint đăng ký
app.post('/register', async (req, res) => {
  const { password, email } = req.body;
  console.log(req.body)
  try {
    // Kiểm tra xem tài khoản đã tồn tại chưa
    const existingUser = await User.findOne({ email });

    if (existingUser) {
      res.status(400).json({ error: 'Username already exists' });
      return;
    }
    if (!email || !password) {
      res.status(400).json({ error: 'Email and password are required' });
      return;
    }
    if (!emailValidator.validate(email)) {
      res.status(400).json({ error: 'Invalid email format' });
      return;
    }
    // Tạo người dùng mới
    const newUser = new User({ password, email });
    await newUser.save();

    res.status(201).json(newUser);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});
// Endpoint lấy thông tin sản phẩm
app.get('/products', async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/products', async (req, res) => {
  const newProduct = new Product(req.body);

  try {
    await newProduct.save();
    res.status(201).send('Product added successfully');
  } catch (err) {
    res.status(500).send(err);
  }
});
// Endpoint lấy thông tin sản phẩm theo ID
app.get('/products/:productId', async (req, res) => {
  const productId = req.params.productId;

  try {
    // Tìm sản phẩm trong MongoDB theo ID
    const product = await Product.findById(productId);

    if (!product) {
      res.status(404).json({ error: 'Product not found' });
      return;
    }

    res.status(200).json(product);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
app.post('/updateQuantity', async (req, res) => {
  try {
    const { userId, productId, quantity } = req.body;

    // Kiểm tra xem userId và productId có tồn tại không
    console.log(userId)
    console.log(productId)
    console.log(quantity)
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const productIndex = user.bag.findIndex(item => item.product.equals(productId));

    // Kiểm tra xem sản phẩm có trong giỏ hàng của người dùng không
    if (productIndex === -1) {
      return res.status(404).json({ error: 'Product not found in the bag' });
    }

    // Cập nhật quantity cho sản phẩm trong giỏ hàng
    user.bag[productIndex].quantity = quantity;

    // Lưu thay đổi vào database
    await user.save();

    res.status(200).json({ message: 'Quantity updated successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
app.post('/removeProduct', async (req, res) => {
  try {
    
    const { userId, productId} = req.body;

    // Find the user by ID
    const user = await User.findById(userId);
    console.log(userId)
    console.log(productId)

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Check if the product is in the user's bag
    const productIndex = user.bag.findIndex(item => item.product.equals(productId));

    if (productIndex === -1) {
      return res.status(404).json({ error: 'Product not found in the user\'s bag' });
    }

    // Remove the product from the user's bag
    user.bag.splice(productIndex, 1);

    // Save the updated user
    await user.save();

    res.json({ message: 'Product removed from the bag successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
// Endpoint lấy thông tin người dùng theo ID
app.get('/:userId', async (req, res) => {
  const userId = req.params.userId;

  try {
    // Tìm người dùng trong MongoDB
    const user = await User.findById(userId);

    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/user/:userId/bag', async (req, res) => {
  try {
    const userId = req.params.userId;
    const productId = req.body.productId; // Giả sử bạn gửi productId từ request body
    const quantity = req.body.quantity ; // Nếu quantity không được gửi, mặc định là 1

    // Kiểm tra xem người dùng có tồn tại không
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Kiểm tra xem sản phẩm có tồn tại không
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    // Kiểm tra xem quantity có lớn hơn 0 không
    if (quantity <= 0) {
      return res.status(400).json({ error: 'Invalid quantity' });
    }

    // Kiểm tra xem sản phẩm đã tồn tại trong bag hay chưa
    const existingProduct = user.bag.find((item) => item.product.equals(productId));
    if (existingProduct) {
      // Nếu sản phẩm đã tồn tại, tăng số lượng
      existingProduct.quantity += quantity;
    } else {
      // Nếu sản phẩm chưa tồn tại và quantity > 0, thêm vào bag
      if (quantity > 0) {
        user.bag.push({ product: productId, quantity });
      } else {
        return res.status(400).json({ error: 'Invalid quantity' });
      }
    }

    // Lưu thông tin người dùng sau khi thay đổi
    await user.save();

    return res.status(200).json({ message: 'Product added to bag successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Định nghĩa endpoint GET để lấy thông tin sản phẩm trong giỏ hàng của người dùng
app.get('/user/bag/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;

    // Kiểm tra xem người dùng có tồn tại không
    const user = await User.findById(userId).populate({
      path: 'bag.product',
      model: 'Product', // Thay 'Product' bằng tên mô hình sản phẩm của bạn
    });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Trả về thông tin giỏ hàng của người dùng
    res.status(200).json({ bag: user.bag });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});



app.post('/update-password/:userId', async (req, res) => {
  const userId = req.params.userId;
  const { oldPassword, newPassword} = req.body;

  try {
    // Tìm người dùng trong MongoDB
    const user = await User.findById(userId);

    if (!user) {
      res.status(404).json({ error: 'User not found' });
      return;
    }

    // Kiểm tra mật khẩu cũ
    const isPasswordValid = oldPassword === user.password;

    if (!isPasswordValid) {
      res.status(401).json({ error: 'Invalid old password' });
      return;
    }

    // Update the user's information
    let updatedUser = {
      password: newPassword ? newPassword : user.password,
    };

    // Update the user in the database
    const updatedUserDoc = await User.findByIdAndUpdate(userId, updatedUser, { new: true });
    console.log(updatedUserDoc)
    res.status(200).json(updatedUserDoc);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Khởi động server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
