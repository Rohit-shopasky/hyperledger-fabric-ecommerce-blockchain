const query = require("./query.js");

module.exports={
    async queryAllProducts(ctx){
        let queryString = {};
        queryString.selector = {
            "_id": {
                "$gt": null
             }
          };
        let allResults = await query.runQuery(ctx,queryString);
        console.log(allResults)
        return allResults;
    }
}