# Sdk::Telefonica

[![](version.svg)]()

This is the plugin Gem to talk to [Telefonica](http://telefonica.com) clouds via sdk.

### Gem Installation Steps
* Download the sdk-telefonica gem file<br>
* Copy the path of gem file and go to that location using CLI.<br>
  Eg. `cd C:\Users\john.smith\Desktop\Gems`<br>
* Install sdk-telefonica gem.<br>
  Eg. `gem install sdk-telefonica-0.0.1.gem`<br>
* Execute bundle.<br>
  Eg. `gem install bundler`
* Go to the location where ruby gems are available, here you can find sdk-telefonica-0.0.1 gem directory.

### Initial Setup

**Require the gem:**

```ruby
require "sdk/telefonica"
```

**Checklist:**

* Before you can do anything with an Telefonica cloud, you need to authenticate yourself with the dentity service, "Keystone".
* All following examples assume that `@connection_params` is a hash of valid connection information for an Telefonica cloud.
* The `:telefonica_username` and `:telefonica_api_key` keys must map to a valid user/password combination in Keystone.

Connection parameters:

```ruby
@connection_params = {
  telefonica_auth_url:     "https://iam.sa-brazil-1.telefonicaopencloud.com/v3/auth/tokens",
  telefonica_username:     "admin",
  telefonica_api_key:      "password",
  telefonica_domain_name:  "domain_name",
  telefonica_project_name: "project_name",
  telefonica_region:       "region_id"
}
```

### Compute (Nova)

**_Initialise_** a connection to the compute service:

```ruby
compute = Sdk::Compute::Telefonica.new(@connection_params)
```

**_Update_** the specification of an ECS instance:

```ruby
p compute.update_ecs_specifications('server_id', 'flavor_id')
```

**_Reboot_** an ECS instance:

```ruby
p compute.restart_servers_in_batches(['server_id1','server_id2'], 'type');
```

### Further Reading

* Read the [Telefonica API documentation](http://support.telefonicaopencloud.com/en-us/api_list/index.html).
* Also, remember that reading the code itself is the best way to educate yourself on how best to interact with this gem.

### Gem Testing
sdk-telefonica-0.0.1 gem currently supports following interfaces:
* Querying Task Status
* Show Floating IP
* Modifying the Specifications of an ECS
* Starting ECSs in Batches
* Stop ECSs in Batches
* Restarting ECSs in Batches
* Lock the VM
* Unlock the VM

To test sdk-telefonica-0.0.1 gem, examples are available in example directory under gem **sdk-telefonica-0.0.1** directory.
