const express = require("express");
const ejs = require("ejs");
const path = require("path");
require("dotenv").config();
const { dbConnect } = require("./data/database");
const bodyParser = require("body-parser");
const flash = require("connect-flash");
const cookieParser = require("cookie-parser");
const { nextTick } = require("process");
const app = express();

app.set("view engine", "ejs");

app.use(cookieParser())
app.use(flash());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(express.static(path.join(path.resolve(),"public")));


const isAuthenticated = ((req,res,next)=>{
    const token = req.cookie
    if(token){
        next();
    }
    else{
        res.render("login.ejs");
    }
});


app.get("/",isAuthenticated,(req,res)=>{
    res.redirect("/logout");
})

app.get("/login",(req,res)=>{
    console.log(req.cookies)

    res.render("login.ejs");
});

app.post("/login",(req,res)=>{

        res.cookie("token","iamin",{
        httpOnly:true,
        expires: new Date(Date.now()+60*1000), //1hr
        })
        res.redirect("/logout")
});

app.get("/logout",(req,res)=>{
    console.log(req.cookies)

    res.cookie("token","iamin",{
        httpOnly:true,
        expires: new Date(Date.now()), //1hr
    })
    res.render("logout.ejs")
});

app.listen(5000, () => {
    console.log("server working")
})


