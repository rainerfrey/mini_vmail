RESTful API for MiniVmail
=========================

Objects
-------
* domain: domain names for which mail is receive. has a name, and an ID for referencing the domain in mailboxes and forwards
* mailbox: a mailbox belongs_to a domain, has a name (i.e. local part), password and domain id
* forward: belongs_to a domain, has a name (i.e. local part), a domain id, and a destination. destination may be a full email address, or a name only, which is then interpreted within the forward's domain


URLs
----
Here is the overview over the URLs to above object resources:

    GET    /domains(.:format)                        get list of domains.
    POST   /domains(.:format)                        (needs admin privileges)
    GET    /domains/new(.:format)                    (needs admin privileges)
    GET    /domains/:id(.:format)                    get a single domain
    PUT    /domains/:id(.:format)                    (needs admin privileges)
    DELETE /domains/:id(.:format)                    (needs admin privileges)
    GET    /mailboxes(.:format)                      get list of mailboxes. 
    POST   /mailboxes(.:format)                      add a new mailbox with mailbox data in POST body (in requested format)
    GET    /mailboxes/new(.:format)                  get an empty template mailbox object in requested format with all relevant attributes
    GET    /mailboxes/:id(.:format)                  get a single mailbox
    PUT    /mailboxes/:id(.:format)                  update a single existing mailbox (object in PUT body)
    DELETE /mailboxes/:id(.:format)                  destroy mailbox with specified ID, no request body
    GET    /forwards(.:format)                       get list of forwards
    POST   /forwards(.:format)                       add a new forward with  data in POST body (in requested format)
    GET    /forwards/new(.:format)                   get an empty template forward
    GET    /forwards/:id(.:format)                   get a single forward
    PUT    /forwards/:id(.:format)                   update a single existing forward
    DELETE /forwards/:id(.:format)                   delete the forward
 
Formats
=======
* XML: e.g. /mailboxes.xml, /mailboxes/new.xml, see template by calling new.xml
* JSON: e.g. /mailboxes.json, /mailboxes/new.json, see template by calling new.json
 * JSON requires a root mapping with object type name
 * {"mailbox":{"name":"..." ...}} instead of only {"name":"..." ...}
    
Query Parameters
================
all object lists can be filtered by query parameters:
* name_like=<value> performs a SQL "name LIKE '%<value>%'" query. available on domains, mailboxes and forwards
* domain_id=<id> filters by associated domain. available on mailboxes and forwards
	
Mailbox attributes
==================

attribute                | type     | required        | notes
---------                | ----     | --------        | -----
name                     | string   | yes             | email local part
my_password              | string   | (when creating) | only to change or initially set password
my_password_confirmation | string   | (when creating) | necessary when setting password
domain_id                | integer  | yes             | referenced domain must exist
active                   | boolean  | no              | must be true to receive mails
notes                    | text     | no              | purely informational text notes
id                       | integer  | read-only       | object id, must not be present when creating, preserved when updating
created_by               | string   | read-only       | user that initially mailbox  
updated_by               | string   | read-only       | user that last updated mailbox 
created_at               | datetime | read-only       | time of creation
updated_at               | datetime | read-only       | last change time

Example series of calls
=======================
To create a mailbox "test@example.com", calls may look like:

    domain = GET /domains.json?name_like=example.com
    template = GET /mailboxes/new.json
    template.setName("test")
    template.setMyPassword("secret")
    template.setMyPasswordConfirmation("secret")
    template.setDomainId(domain.id)
    template.setActive(true)
    POST /mailboxes.json
    template.toJson