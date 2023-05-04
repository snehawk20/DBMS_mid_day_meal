const { text } = require("body-parser");
const pkg  = require("pg");
const {Client} = pkg;

const client = new Client({
    host:"localhost",
    user:"postgres",
    port:5432,
    password:'1234',
    database: "mdm"
});

const loginClient = (userId,password)=>{

    return new Client({
    user: userId,
    password: password,
    host:'localhost',
    port:5432,
    database: "mdm"
});
}

const userSchema = new Client({
    email: text,
    password: text,
})

// const User = client.model("user", userSchema)

client.connect()
.then(()=>console.log("Database Connected"))
.catch((e)=>console.log(e));

// var viewData = `select * from school`
// client.query(viewData, (err, result) => {
//     if (err) throw err;
//     else {
//         console.log(result.rows)
//     }
// });

exports.dbConnect = client; 
exports.userSchema = userSchema;
exports.loginClient = loginClient;