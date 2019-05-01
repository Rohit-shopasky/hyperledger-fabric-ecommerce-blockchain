
'use strict';

const { Contract } = require('fabric-contract-api');
// import functions
const all_products = require("./methods/all_products.js");
const buy          = require("./methods/buy.js");
const orders       = require("./methods/orders.js");

class Chaincode extends Contract {

    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        const items = [
            {
                type:'gadgets',
                model:'G1',
                name:'Smartphone',
                price:'1000',
                sku_id:1
            },
            {
              type:'electronics',
              model:'E1',
              name:'AirCondition',
              price:'2000',
              sku_id:2
 
            },
            {
                type:'garments',
                model:'ga1',
                name:'T-shirt',
                price:'200',
                sku_id:3
            },
            {
                type:'gadgets',
                model:'G2',
                name:'Laptop',
                price:'5000',
                sku_id:4
            }
        ]

        for (let i = 0; i < items.length; i++) {
            
            items[i].docType = "products";
            await ctx.stub.putState('Item' + i, Buffer.from(JSON.stringify(items[i])));
        
        }
        console.log("Ledger init success!");
    }

    async queryAllProducts(ctx){
    console.log("Query all products called!");
       let allResults = await all_products.queryAllProducts(ctx);
       return allResults;    
    }

    async buyProduct(ctx){
        console.log("Buy product called")
        let response = {}
      const bought_product = await buy.buyProduct(ctx);
      if (bought_product==-1)
      response.msg="3 Arguments required (Item_id, Customer_name, qunatity)";
      else
      response.msg="Order Placed";
      return response;
    }

    async myOrders(ctx)
    {
        console.log("My orders called");
        let response = {};
        const allOrders = await orders.myOrders(ctx);
        response.data = allOrders;
        return response;
    }

    async allOrders(ctx){
        console.log("All Orders called");
        const allOrders = await orders.allOrders(ctx);
        return allOrders;
    }

    async changeOrderStatus(ctx){
        console.log("Change order status called");
        let response = {};
        let result = await orders.changeOrderStatus(ctx);
        if(result==-1)
        response.msg="2 Args required";
        else if(result==-2)
        response.msg = "Order not found";
        else
        response.msg="Order Status changed to " + result;
        return response;
  }
    

}


module.exports = Chaincode;