const express = require('express');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const cors = require('cors');
const helmet = require('helmet');
const dotenv = require('dotenv');
const corsConfig = require('./config/corsOptions')

//importing middlewares
const {notFound, errorHandler} = require('./middleware/errorMiddleware');

//configurations
const app = express();
dotenv.config();

//body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

//extra security
app.use(helmet());
app.use(helmet.crossOriginResourcePolicy({ policy: 'cross-origin' }));

//for morgan I can either use common, dev, short or combined
app.use(morgan("common"));

//cookie parser
app.use(cookieParser());


app.use(
  cors(corsConfig)
);

//using static folder
app.use('/uploads', express.static(__dirname + '/uploads'));


//Routes
app.use('/account', require('./routes/account/index'));
app.use('/validation', require('./routes/validation/index'))
app.use('/app',require('./routes/app/index'))
app.use('/manager', require('./routes/manager/index'))



//Middlewares
app.use(notFound);
app.use(errorHandler);

//Notifications
const server = require('http').createServer(app);
const io = require("socket.io")(server, {
  cors: corsConfig
});

io.on('connection', (socket) => {
    //demo
    io.emit('broadcast','connected')
})

const PORT = process.env.PORT || 8000;

server.listen(PORT, () =>console.log (`Server started on port ${PORT}`));
