resource "azurerm_lb_probe" "lb" {
    count = length(var.lb_port)
    resource_group_name = var.resource_group_name
    loadbalancer_id = var.loadbalancer_id
    name = element(keys(var.lb_port), count.index)
    protocol = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
    port = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
    interval_in_seconds = var.lb_probe_interval
    number_of_probes = var.lb_probe_unhealthy_threshold
}

resource "azurerm_lb_rule" "lb" {
    count = length(var.lb_port)
    resource_group_name = var.resource_group_name
    loadbalancer_id = var.loadbalancer_id
    name = element(keys(var.lb_port), count.index)
    protocol = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
    frontend_port = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
    backend_port = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    enable_floating_ip = false
    backend_address_pool_ids = [ var.backend_id ]
    idle_timeout_in_minutes = 5
    probe_id = element(azurerm_lb_probe.lb.*.id, count.index)
    depends_on = [azurerm_lb_probe.lb]
}
