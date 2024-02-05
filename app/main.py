# Import necessary libraries
import torch
from torchvision import models, transforms
from PIL import Image

# Load the pre-trained ResNet model
model = models.resnet50(pretrained=True)
model = model.eval()

# Image transformations
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

def classify_image(image_path):
  # Open and transform image
  img = Image.open(image_path).convert('RGB')
  img_t = transform(img).unsqueeze(0)

  # Forward pass
  with torch.no_grad():
      out = model(img_t)

  _, predicted = torch.max(out, 1)

  print(f'Predicted: {predicted.item()}')

# Test the function
classify_image('corgis.jpg')