const { CompanyModel } = require('../models/company');
const { SiteModel } = require('../models/site');
const { TaskModel } = require('../models/task');

module.exports = {

    createSite: async (req, res) => {
        const company = await Company.findOne({ _id: req.body.company });
        if (company) {
            SiteModel.create({
                company: req.body.company,
                name: req.body.name,
                address: req.body.address,
                description: req.body.description,
            }, function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    res.status(200).send({ status: 'success', message: 'site_created' });
                } else {
                    res.status(404).send({ status: 'error', message: 'site_not_created' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'company_not_found' });
        }
    },

    updateSite: async (req, res) => {
        const site = await SiteModel.findOne({ _id: req.body.id });
        if (site) {
            site.name = req.body.name;
            site.address = req.body.address;
            site.description = req.body.description;
            site.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'site_updated' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'site_not_found' });
        }
    },

    removeSite: async (req, res) => {
        const site = await SiteModel.findOne({ _id: req.body.id });
        if (site) {
            site.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'site_removed' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'site_not_found' });
        }
    },

    createTask: async (req, res) => {
        const site = await SiteModel.findOne({ _id: req.body.site });
        if (site) {
            TaskModel.create({
                site: req.body.site,
                label: req.body.label,
                description: req.body.description,
                status: 0,
                priority: req.body.priority,
                assigned: req.body.assigned,
                trade: req.body.trade,
                site: req.body.site,
                start: req.body.start,
                end: req.body.end,
            }, function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else if (doc) {
                    res.status(200).send({ status: 'success', message: 'task_created' });
                } else {
                    res.status(404).send({ status: 'error', message: 'task_not_created' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'site_not_found' });
        }
    },

    updateTask: async (req, res) => {
        const task = await TaskModel.findOne({ _id: req.body.id });

        if (task) {
            task.label = req.body.label;
            task.description = req.body.description;
            task.status = req.body.status;
            task.priority = req.body.priority;
            task.assigned = req.body.assigned;
            task.trade = req.body.trade;
            task.site = req.body.site;
            // task.start = req.body.start;
            // task.end = req.body.end;
            task.save(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'task_updated' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'task_not_found' });
        }
    },

    removeTask: async (req, res) => {
        const task = await TaskModel.findOne({ _id: req.body.id });

        if (task) {
            task.remove(function(err, doc) {
                if (err) {
                    res.status(404).send({ status: 'error', message: err });
                } else {
                    res.status(200).send({ status: 'success', message: 'task_removed' });
                }
            });
        } else {
            res.status(404).send({ status: 'error', message: 'task_not_found' });
        }
    },
    
};