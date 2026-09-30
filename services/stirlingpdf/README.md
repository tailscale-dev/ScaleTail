# Stirling-PDF with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) with Tailscale as a sidecar container to securely manage and manipulate PDF files over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your PDF processing, ensuring that the Stirling-PDF interface is only accessible within your Tailscale network.

## Stirling-PDF

Stirling-PDF is a versatile, open-source toolkit that allows you to perform various PDF manipulations, such as merging, splitting, compressing, and converting PDF files. With an intuitive and user-friendly interface, Stirling-PDF simplifies complex PDF tasks, making it a valuable tool for both personal and professional use. This configuration leverages Tailscale to securely connect to your Stirling-PDF instance, protecting your sensitive document operations from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-stirlingpdf` service runs Tailscale, which manages secure networking for the Stirling-PDF service. The `stirlingpdf` service uses the Tailscale network stack via Docker’s `network_mode: service:tailscale` configuration. This setup ensures that Stirling-PDF's interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your PDF processing tasks.
