import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np


class ConvNet(nn.Module):
    def __init__(self, in_channels, height, width):
        super(ConvNet, self).__init__()
        self.height = height
        self.width = width

        # Convolutional layers (similar to AlphaGo's architecture)
        self.conv1 = nn.Conv2d(in_channels, 64, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        self.conv3 = nn.Conv2d(128, 256, kernel_size=3, padding=1)

        # Fully connected layer to output a score for each position on the 2D map
        self.fc1 = nn.Linear(256 * height * width, height * width)

    def forward(self, x):
        # Assume x has shape (batch_size, channels, height, width)
        batch_size = x.size(0)

        # Extract "is_in_game" feature from the input (assume it's the last channel)
        is_in_game = x[:, -1, :, :]  # Shape: (batch_size, height, width)

        # Pass through convolutional layers
        x = F.relu(self.conv1(x))
        x = F.relu(self.conv2(x))
        x = F.relu(self.conv3(x))

        # Flatten the features for the fully connected layer
        x = x.view(batch_size, -1)  # Shape: (batch_size, 256 * height * width)

        # Output a score for each coordinate on the 2D map
        logits = self.fc1(x)  # Shape: (batch_size, height * width)

        # Reshape logits to 2D (height, width) for each batch
        logits = logits.view(batch_size, self.height, self.width)

        # Mask out invalid positions using the "is_in_game" feature
        # Set logits to a very low value (-inf) where is_in_game == 0
        masked_logits = logits.masked_fill(is_in_game == 0, float('-inf'))

        # Apply softmax to get a probability distribution over valid positions
        prob_map = F.softmax(masked_logits.view(batch_size, -1), dim=1)  # Shape: (batch_size, height * width)

        # Sample the output coordinate based on the probability map
        coord_idx = torch.multinomial(prob_map, 1)  # Shape: (batch_size, 1)

        # Convert the index into 2D coordinates
        x_coords = coord_idx // self.width
        y_coords = coord_idx % self.width

        # Stack the coordinates to get (x, y) pairs
        coords = torch.stack((x_coords, y_coords), dim=-1)  # Shape: (batch_size, 2)

        return coords
