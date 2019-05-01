const query = require("./query.js");
let order_id=0;

module.exports={
    async buyProduct(ctx){

        let ret = ctx.stub.getFunctionAndParameters();
        let args = ret.params;

        if(args.length<3)
        {
            return -1;
        }

        let product = {};
        product.item_id = args[0];
        product.customer_name = args[1];
        product.quantity = args[2];
        product.order_status = "placed";
        product.docType = "orders";
    
        let key = ++ order_id;
        // insert order into db
        await ctx.stub.putState(key.toString(), Buffer.from(JSON.stringify(product)));
        return 1;

    }
}
