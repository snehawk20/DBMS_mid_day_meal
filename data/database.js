const pkg  = require("pg");
const {Client} = pkg;

const client = new Client({
    host:"localhost",
    user:"postgres",
    port:5432,
    password:'1234',
    database: "mdmproject"
});


client.connect()
.then(()=>console.log("Database Connected"))
.catch((e)=>console.log(e));


exports.dbConnect = client; 