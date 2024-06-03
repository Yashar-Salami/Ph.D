#include <iostream>
#include <string>

// Curve parameters
const int a = 2;
const int b = 3;
const int p = 17; // Prime number

// Point on the curve
struct Point {
    int x, y;
};

// Function to add two points on the curve
Point addPoints(Point P, Point Q) {
    Point R;
    
    int lambda, inv;
    
    if (P.x == Q.x && P.y == Q.y) {
        lambda = ((3 * P.x * P.x + a) * (2 * P.y)) % p;
        inv = 1;
    } else {
        lambda = ((Q.y - P.y) * ((Q.x - P.x) + p)) % p;
        inv = ((Q.x - P.x) + p) % p;
    }
    
    for (int i = 1; i < p; i++) {
        if ((lambda * i) % p == 1) {
            inv = i;
            break;
        }
    }
    
    R.x = (lambda * lambda - P.x - Q.x) % p;
    R.y = (lambda * (P.x - R.x) - P.y) % p;
    
    return R;
}

// Encrypt a message using the elliptic curve cryptography
std::string encryptMessage(std::string message, Point publicKey) {
    std::string encryptedMessage = "";
    
    for (char c : message) {
        Point P = {c % p, c % p}; // Generate a point on the curve based on the character
        
        Point Q = addPoints(P, publicKey); // Add the public key to the point
        
        encryptedMessage += std::to_string(Q.x) + " " + std::to_string(Q.y) + " ";
    }
    
    return encryptedMessage;
}

int main() {
    Point publicKey = {5, 1}; // Public key point
    
    std::string message = "Hello, World!";
    
    std::string encryptedMessage = encryptMessage(message, publicKey);
    
    std::cout << "Encrypted message: " << encryptedMessage << std::endl;
    
    return 0;
}