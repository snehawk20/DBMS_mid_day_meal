const express = require("express");
const ejs = require("ejs");
const session = require('express-session');
const path = require("path");
require("dotenv").config();
const { dbConnect } = require("./data/database");
const bodyParser = require("body-parser");
const flash = require("connect-flash");

// const cookieParser = require("cookie-parser");
// const { nextTick } = require("process");
const app = express();


app.use(session({
    secret: 'key',
    resave: false,
    saveUninitialized: true
  
  
}));
  


app.set("view engine", "ejs");


// app.use(cookieParser())
app.use(flash());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(bodyParser.json());
app.use(express.static(path.join(path.resolve(),"public")));


// const isAuthenticated = ((req,res,next)=>{
//     const token = req.cookie
//     if(token){
//         next();
//     }
//     else{
//         res.render("login.ejs");
//     }
// });


app.get("/",(req,res)=>{
    res.redirect("/login");
})

app.get("/login",(req,res)=>{
    // console.log(req.cookies)
    // console.log(res.body);
    res.render("login.ejs");
});

app.post("/login",(req,res)=>{
    // console.log(req.body);
    const {username, password, Role} = req.body
    // console.log(username,password,Role)
    req.session.userData = [username,password]
    if(Role =='school'){
        res.redirect(`/school/${username}`);
    }
    else if(Role =='city'){
        res.redirect(`/city/${username}`)
    }
    else if(Role =='district'){
        res.redirect(`/district/${username}`) 
    }
    // res.redirect("/logout");
});

app.get("/logout",(req,res)=>{
    res.redirect('/login')
});


const schoolRoute = require('./routes/school')
app.use("/school",schoolRoute)

const cityRoute = require('./routes/city')
app.use("/city",cityRoute)

const districtRoute = require('./routes/district')
app.use("/district",districtRoute)


app.listen(5000, () => {
    console.log("server working")
})




// const isAuthenticated = ((req,res,next)=>{
//     const token = req.cookie
//     if(token){
//         next();
//     }
//     else{
//         res.render("login.ejs");
//     }
// });


// app.get("/",isAuthenticated,(req,res)=>{
//     res.redirect("/logout");
// })

// app.get("/login",(req,res)=>{
//     console.log(req.cookies)

//     res.render("login.ejs");
// });

// app.post("/login",(req,res)=>{

//         res.cookie("token","iamin",{
//         httpOnly:true,
//         expires: new Date(Date.now()+60*1000), //1hr
//         })
//         res.redirect("/logout")
// });

// app.get("/logout",(req,res)=>{
//     console.log(req.cookies)

//     res.cookie("token","iamin",{
//         httpOnly:true,
//         expires: new Date(Date.now()), //1hr
//     })
//     res.render("logout.ejs")
// });
