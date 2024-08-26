let
  pylon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsNDYN8h93HAYAqgi4oIgvM0zlfsE7cl/cfPuw68jXm root@pylon";
  drone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVjPDqpK/UP5RzRE3bEcnrwtlH89q6F52zGPiS1+fl0 cfcosta@drone.local";

  users = [
    drone
    pylon
  ];
in
{
  "secrets/tailscale.age".publicKeys = users;
}
