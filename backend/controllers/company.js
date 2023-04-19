const { CompanyModel } = require('../models/company');
const { RoleModel } = require('../models/role');
const { TradeModel } = require('../models/trade');

module.exports = {
    
    create: async (req, res) => {
        const company = await CompanyModel.create({
            name: req.body.name,
            description: req.body.description,
        });

        if (company) {
            res.status(200).send({ status: 'success', message: 'company_created' });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_created' });
        }
    },

    update: async (req, res) => {
        const company = await CompanyModel.findOne({ _id: req.body.id });
        if (company) {
            company.name = req.body.name;
            company.description = req.body.description;
            company.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'company_updated' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    createRole: async (req, res) => {
        const company = await CompanyModel.findOne({ _id: req.body.company });
        if (company) {
            RoleModel.create({
                company: req.body.company,
                name: req.body.name,
                description: req.body.description,
                features: req.body.features,
            }, function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    res.status(200).send({ status: 'success', message: 'role_created' });
                } else {
                    res.status(404).send({ status: 'error', message: 'role_not_created' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    updateRole: async (req, res) => {
        const role = await RoleModel.findOne({ _id: req.body.id });
        if (role) {
            role.name = req.body.name;
            role.description = req.body.description;
            role.features = req.body.features;
            role.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'role_updated' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'role_not_found' });
        }
    },

    removeRole: async (req, res) => {
        const role = await RoleModel.findOne({ _id: req.body.id });
        if (role) {
            role.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'role_removed' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'role_not_found' });
        }
    },

    createTrade: async (req, res) => {
        const company = await CompanyModel.findOne({ _id: req.body.company });
        if (company) {
            TradeModel.create({
                company: req.body.company,
                name: req.body.name,
                description: req.body.description,
            }, function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    res.status(200).send({ status: 'success', message: 'trade_created' });
                } else {
                    res.status(404).send({ status: 'error', message: 'trade_not_created' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    updateTrade: async (req, res) => {
        const trade = await TradeModel.findOne({ _id: req.body.id });
        if (trade) {
            trade.name = req.body.name;
            trade.description = req.body.description;
            trade.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    res.status(200).send({ status: 'success', message: 'trade_updated' });
                } else {
                    res.status(404).send({ status: 'error', message: 'trade_not_updated' });
                }   
            });
        } else {
            res.status(404).send({ status: 'error', message: 'trade_not_found' });
        }
    },

    removeTrade: async (req, res) => {
        const trade = await TradeModel.findOne({ _id: req.body.id });
        if (trade) {
            trade.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'trade_removed' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'trade_not_found' });
        }
    }
    
};