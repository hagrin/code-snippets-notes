# Running AI Models Locally

My current belief is that businesses / corporations will greatly utilize AI in the future much in a "As A Service" manner. Due to the likely intense energy and capex costs, corporations will likely put non-sensitive business functions in the cloud with AI providers that have built out their own datacenters / energy supply. However, this leaves sensitive, intellectual property (IP) business functions that corporations will likely be very unwilling to run in the cloud. While AI services companies will likely state that they won't store any data, with the hunger for new, non-AI generated training data, my guess is that AI companies will find a way to train on submitted prompts and data which could expose your company's IP. Therefore, my belief is that there will be some small subset of AI functions that companies will choose to run locally while not having the insane energy demands of running larger core business operations. This document tries to explore "at home" AI setups for possible rollout.

## Hardware

As of right now (March 2025) there's 3+ different tracks companies / individuals can go down to potentially accomplish running AI models locally - 
* Purchase an Nvidia Tensor Core GPU
* Purchase something like tinybox which improves the performance/$$$ ratio over just a base Tensor Core GPU
* Purchase retail / consumer hardware and hack together an in-house solution utilizing open source models

Since the first two options are a bit more straightforward, I will focus mainly on the third option which will be accessible to a wider audience.

### The Rise of the M4 and the Mac Mini

While Sam Altman and OpenAI clamor for an "AI moat" to protect their interests, there are many efforts that believe that AI efforts should be accessible using whatever hardware / devices that individuals could easily access. For this to be possible, there would need to be a two prong effort - accessible hardware and software that made efficiency gains in LLMs and other models to lower the hardware requirement bar. One of those hardware hurdles comes in the form of GPU prices. Whether the H or A series Nvidia offerings or the 40xx series GPUs, the price tags associated to these offerings are currently expensive and subject to very high demand. Enter the Apple Mac Mini.<br />

In order to better leverage their Silicon chips, Apple developed MLX which, on Apple hardware, can perform better than PyTorch. With the Apple Silicon, MLX and other efficiency gains, Mac Minis were discovered to not only be AI capable, but to consume far less power than their GPU counterparts. Next, research started being conducted on the performance of these Mac Minis when clustered vs single instances and then when running small vs large models.

https://www.apple.com/shop/buy-mac/mac-mini

https://github.com/exo-explore/exo
