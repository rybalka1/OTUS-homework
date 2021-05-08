"""Role testing files using testinfra."""


def test_hosts_file(host):
    """Validate /etc/hosts file."""
    f = host.file("/etc/hosts")

    assert f.exists
    assert f.user == "root"
    assert f.group == "root"


def test_nginx_installed(host):
    nginx = host.package("nginx")
    nginx_required_version = "1.19.1"

    assert nginx.is_installed
    assert nginx.version.startswith(nginx_required_version)


def test_nginx_config(host):
    nginx_site_config = host.file("/etc/nginx/conf.d/example.com.conf")

    assert nginx_site_config.exists
    assert nginx_site_config.is_file
    assert nginx_site_config.user == 'root'
    assert nginx_site_config.group == 'root'
    assert oct(nginx_site_config.mode) == '0o644'


def test_nginx_service(host):
    nginx_service = host.service("nginx")

    assert nginx_service.is_running
    assert nginx_service.is_enabled


def test_nginx_port(host):
    nginx_socket = host.socket("tcp://0.0.0.0:8085")

    assert nginx_socket.is_listening


def test_curl(host):
    cmd = host.run("curl -s http://127.0.0.1:8085")

    assert cmd.rc == 0
