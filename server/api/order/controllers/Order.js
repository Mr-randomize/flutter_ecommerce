'use strict';

const axios = require('axios');
const stripe = require('stripe')('sk_test_51I45EMB7RQGmh2XXdYWEvSIdrZYlbz7I9naBqD99LpSfOktQdDqFzruz7UumNx6OQuanxc8XyxqG5HZe0IJSY9rt00EK0s4kn0');
try {
    const uuid = require('uuid/v4');
} catch (error) {
    const { v4: uuid } = require('uuid');
}

/**
 * Order.js controller
 *
 * @description: A set of functions called "actions" for managing `Order`.
 */

module.exports = {

  /**
   * Retrieve order records.
   *
   * @return {Object|Array}
   */

  find: async (ctx) => {
    if (ctx.query._q) {
      return strapi.services.order.search(ctx.query);
    } else {
      return strapi.services.order.fetchAll(ctx.query);
    }
  },

  /**
   * Retrieve a order record.
   *
   * @return {Object}
   */

  findOne: async (ctx) => {
    if (!ctx.params._id.match(/^[0-9a-fA-F]{24}$/)) {
      return ctx.notFound();
    }

    return strapi.services.order.fetch(ctx.params);
  },

  /**
   * Count order records.
   *
   * @return {Number}
   */

  count: async (ctx) => {
    return strapi.services.order.count(ctx.query);
  },

  /**
   * Create a/an order record.
   *
   * @return {Object}
   */

  create: async (ctx) => {

    const {amount, products, customer, source} = ctx.request.body;
    const { email } = ctx.state.user;

    const charge = {
      amount: Number(amount) * 100,
      currency: 'usd',
      customer,
      source,
      receipt_email: email
    };

    const idempotencyKey = uuid();

    await stripe.charges.create(charge,{
      idempotency_key: idempotencyKey
    });

    return strapi.services.order.add({
      amount,
      products: JSON.parse(products),
      user: ctx.state.user
    });
  },

  /**
   * Update a/an order record.
   *
   * @return {Object}
   */

  update: async (ctx, next) => {
    return strapi.services.order.edit(ctx.params, ctx.request.body) ;
  },

  /**
   * Destroy a/an order record.
   *
   * @return {Object}
   */

  destroy: async (ctx, next) => {
    return strapi.services.order.remove(ctx.params);
  }
};
