const express = require('express');
const morgan = require("morgan");
const passport = require("passport");
const db = require("./src/config/db");

const port = process.env.PORT || 3000;
const app = express();

//Middlewares
app.use(morgan("dev"));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());


app.listen(port, () => {
    console.log(`server started on port: ${port}`);
});

app.get("/", (req, res) => {
    res.send('hello world');
})