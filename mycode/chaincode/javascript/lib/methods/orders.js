const query = require("./query.js");
module.exports = {
    async myOrders(ctx){
            console.log("came");
          let ret = ctx.stub.getFunctionAndParameters();
          let args= ret.params;
          if(args.length<1)
          {
              return -1;
          }
          let customer_name = args[0];
          let queryString = {};
          queryString.selector = {
              "customer_name" : customer_name
          }
          let queryResult = await query.runQuery(ctx,queryString);
          return queryResult; 
    } ,
    
    async allOrders(ctx){
        console.log("came");
        let queryString = {};
        queryString.selector = {
            "docType" : "orders"
        }
        let queryResult = await query.runQuery(ctx,queryString);
        return queryResult;
    },

    async changeOrderStatus(ctx){
        console.log("came");
        let ret = ctx.stub.getFunctionAndParameters();
        let args = ret.params;
        if(args.length<2)
        {
            return -1;
        }
        let order_id = args[0];
        let newStatus = args[1];
        const orderAsBytes = await ctx.stub.getState(order_id); // get the order from chaincode state
        if (!orderAsBytes || orderAsBytes.length === 0) {
            return -2;
        }
        let order = JSON.parse(orderAsBytes.toString());
        order.order_status = newStatus;
        await ctx.stub.putState(order_id.toString(), Buffer.from(JSON.stringify(order)));
        return newStatus;

    }

    

}