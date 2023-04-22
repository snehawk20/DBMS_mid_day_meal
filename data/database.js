const { text } = require("body-parser");
const pkg  = require("pg");
const {Client} = pkg;

const client = new Client({
    host:"localhost",
    user:"postgres",
    port:5432,
    password:'1234',
    database: "mdmproject"
});

const userSchema = new Client({
    email: text,
    password: text,
})

// const User = client.model("user", userSchema)

client.connect()
.then(()=>console.log("Database Connected"))
.catch((e)=>console.log(e));


exports.dbConnect = client; 
exports.userSchema = userSchema;