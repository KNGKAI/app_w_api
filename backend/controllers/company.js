const { CompanyModel, CompanyyModel } = require('../models/company');

module.exports = {

    update: async (req, res) => {
        const company = await CompanyModel.findOne({ _id: req.params.id });
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
        const company = await CompanyModel.findOne({ _id: req.params.id });
        if (company) {
            const role = await RoleModel.create({
                name: req.body.name,
                description: req.body.description,
                features: req.body.features,
            });
            company.roles.push(role.id);
            company.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'role_created' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    updateRole: async (req, res) => {
        const role = await RoleModel.findOne({ _id: req.params.id });
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

    deleteRole: async (req, res) => {
        const role = await RoleModel.findOne({ _id: req.params.id });
        if (role) {
            role.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    CompanyyModel.updateOne({ roles: role.id }, { $pull: { roles: role.id } }, function(err, updated) {
                        if (err) {
                            res.status(404).send({ status: 'error', message: err });
                        } else if (updated) {
                            res.status(200).send({ status: 'success', message: 'role_deleted' });
                        } else {
                            res.status(404).send({ status: 'error', message: 'company_not_updated' });
                        }
                    });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'role_not_found' });
        }
    },

    createUser: async (req, res) => {
        const company = await CompanyModel.findOne({ _id: req.params.id });
        if (company) {
            var general = null;
            company.roles.forEach(async (role) => {
                if (role.features === 0) {
                    role = role.id;
                }
            });
            if (general) {
                const user = await UserModel.create({
                    username: req.body.username,
                    email: req.body.email,
                    role: general,
                });
                company.users.push(user.id);
                company.save(function(err, doc) {
                    if (err) {
                        res.status(404).send({ status: 'error', message: err });
                    } else {
                        res.status(200).send({ status: 'success', message: 'user_created' });
                    }
                });
            } else {
                res.status(404).send({ status: 'error', message: 'general_role_not_found' });
            }
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    removeUser: async (req, res) => {
        const user = await UserModel.findOne({ _id: req.params.id });
        if (user) {
            user.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    CompanyModel.updateOne({ users: user.id }, { $pull: { users: user.id } }, function(err, updated) {
                        if (err) {
                            res.status(404).send({ status: 'error', message: err });
                        } else if (updated) {
                            res.status(200).send({ status: 'success', message: 'user_deleted' });
                        } else {
                            res.status(404).send({ status: 'error', message: 'company_not_updated' });
                        }
                    });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'user_not_found' });
        }
    },
    
};