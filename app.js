const express = require("express");
const ejs = require("ejs");
const path = require("path");
require("dotenv").config();
const { dbConnect } = require("./data/database");
const bodyParser = require("body-parser");
const flash = require("connect-flash");

const app = express();

app.set("view engine", "ejs");

app.use(flash());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(express.static(path.join(path.resolve(),"public")));


app.get("/login",(req,res)=>{
    res.render("login.ejs");
});

app.post("/login",(req,res)=>{
    
});

app.get("/logout",(req,res)=>{
    res.render("logout.ejs");
});

app.listen(5000, () => {
    console.log("server working")
})


