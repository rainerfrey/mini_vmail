# Welcome to Mini VMail

Mini VMail is a RoR web application to manage virtual users and domains for a mail server.
This is a minimalistic implementation that offers just editing of domains, mailboxes and forwards.
Mini VMail is developed and used with PostgreSQL, but should work with any database that's 
supported by ActiveRecord.

For now, it is very advisable to be familiar with Ruby on Rails application structure and configuration.

Sample configuration files are provided for Dovecot (v2.0) and Postfix, but the database schema 
may be usable by other mail systems as well, as long as mailbox path and delivery user id is configurable in 
the MDA configuration.

Note that this project is developed with limited time, for one specific in-house usage scenario. Flexibility
and usability for other usage may be limited. Still feel free to send me improvement suggestions or even 
pull requests with improvements. 

## Getting Started

1. Adapt config/deploy.rb and deploy Mini VMail with capistrano
2. Open the deployment URL with a browser
3. Follow the instructions to set up the initial administrator account
4. Setup an additional user account to edit just mailbox and forward data
5. Add at least one domain for which you want to receive mails
6. Download the mail server configuration files to your mail server. Database connection details are already filled in.
   Adapt to your needs if necessary
7. Add mailbox and forward (alias) entries

## Configuring virtual mail domains in Postfix

In all described scenarios: never add domains configured in Mini VMail to `mydestination`!

### virtual_mailbox_domains vs. relay_domains
Postfix offers the `virtual_mailbox_domains` address class to deliver mails locally to virtual users. Delivery happens by default with the
included "virtual" delivery agent. This does not work well with Mini VMail as the database does not contain a mailbox path. Therefore an external delivery mechanism such as `dovecot-lda` or LMTP is needed.
While it is possible to configure such a delivery agent for virtual mailbox domains, such a setup is conceptually closer to relaying to an external system. Thus it is best to configure the domains for Mini VMail as `relay_domains`.
As the domains table contains a transport field, the same table can be used as `transport_maps` as well as `relay_domains` map. The default transport for new domains is configured in `config/config.yml`.

### local domains map file vs. SQL lookup configuration
For many mail server setups, the list of hosted domains does not change very often. As local map files are always faster and more robust, you might want to export the domain map and use that in postfix. Use the link at the mail server configuration downloads for that.

* for most cases just use the SQL configuration 
* if your domain list changes very infrequently _and_ you're concerned about limiting the number of SQL queries export the domain list

## Configuring the list of valid recipients for postfix
Recent postfix versions provide recipient address verification which can be used to determine valid addresses for the hosted domains. This only works for SMTP and LMTP destinations. If this is not used, the list of valid recipient must be explicitly configured in postfix, as

* `virtual_mailbox_maps` if the domains are configured as `virtual_mailbox_domains`
* `relay_recipient_maps` if the domains are configured as `relay_domains`

####Guideline:
Use recipient verification if:

* mail is delivered with LMTP or SMTP _and_
* verification cache is properly configured and monitored

Be sure to apply recipient verification only to the destination domains under your own control.

In all other cases use an explicit recipient map.

## Configuring mail aliases in postfix
The forwards table can be used for virtual aliases in postfix. Virtual alias mappings are applied to all mail, but postfix must be configured to accept mails for domains that are used only for aliases. Postfix offers the virtual alias domain address class with the `virtual_alias_domains` list for that, but Mini VMail does not support that.
A relay or virtual mailbox domain with no mailbox recipients, but only alias addresses is almost identical to a specialized virtual alias domain, so just add domains intended for forwards only in Mini VMail, and configure the SQL lookup for `virtual_alias_maps`.


## Configuring Mini VMail
The first user created during setup is an administrator account that can download mail server config, edit domains and add more users through the web interface. All further users are unprivileged users who can only edit mailboxes and forwards. Currently there is no way to configure more administrator users. If needed, this can be achieved by setting admin=true for an existing User object in a database or Rails console.

The default transport is configured in `config/config.yml`, and is used as initial value for new domains. The other settings in `config.yml` may not be changed for now, as that would require code changes right now.
Note that in the repository, `config.yml` and `database.yml` are not directly supplied, but the versions in config/deploy/ are copied to the server by capistrano. To run locally, copy these files to the config/ directory.
