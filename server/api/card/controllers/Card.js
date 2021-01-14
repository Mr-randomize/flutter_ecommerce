'use strict';

const stripe = require('stripe')('sk_test_51I45EMB7RQGmh2XXdYWEvSIdrZYlbz7I9naBqD99LpSfOktQdDqFzruz7UumNx6OQuanxc8XyxqG5HZe0IJSY9rt00EK0s4kn0');

/**
 * A set of functions called "actions" for `Card`
 */

module.exports = {
   index: async (ctx) => {
    const customerId = ctx.request.querystring;
    const customerData = await stripe.customers.retrieve(customerId);
    const cardData = await stripe.customers.retrieveSource(customerId,customerData.default_source);
    console.log(cardData);
    ctx.send(cardData);
   },

  add: async ctx => {
      const { customer, pm } = ctx.request.body;
      const card = await stripe.paymentMethods.attach(pm,  {customer: customer});
      ctx.send(card);
    }
};
