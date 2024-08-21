# BicRF

Biclustering is usually defined as the simultaneous clustering of both rows and columns of a given data matrix. Given a data matrix, biclustering techniques aim to extract subsets of rows that exhibit ``similar'' behavior in a subset of columns (and vice versa). Biclustering was first devised to analyze the expression of genes in microarray data. However, it has recently been used in various applications ranging from clickstream data analysis to recommender systems and computer vision (e.g., facial expression recognition, motion and plane estimation, and region-based correspondences).\
There is a notable absence of RF-based approaches for biclustering in the literature, which is the main focus of this work. In particular, we define an RF-based representation that binarizes the initial complex data, to favor the extraction of hidden biclusters, and we propose BicRF, a novel algorithm that exploits the RF representation, selecting objects and features agreeing on the same tests.


## The Algorithm
We derive the initial representation from a random forest, which involves linearizing decision trees and organizing test outcomes into a binary matrix. This matrix serves as the foundation for the BicRF algorithm, which is designed to extract biclusters from the representation. BicRF operates by initiating regions based on the most similar objects and expanding these regions through a process inspired by region growing, where objects are added based on the percentage of agreeing tests. We further refine our approach using BicRFOpt, which allows for the optimization of bicluster quality by evaluating multiple thresholds and selecting the one that yields the best result. This chapter details the steps involved in each phase of the methodology, from initial representation to final bicluster extraction, providing a comprehensive framework for understanding and applying BicRF in practical scenarios.


### RF Training
The training phase was done employing the Matlab library from [this paper]([http://example.com](https://profs.scienze.univr.it/~bicego/papers/2020_ICPR_On_learning_Random.pdf)). The baseline approach of the library is the classic Random Forest model for classification, but one can also employ ERTs. As a general setup we train a forest of 100 trees, each with a maximum depth of 5. 

### Representation Extraction
Relying on the idea that ''given a tree, we can aggregate the different objects into groups by looking at the path they are following from the root to the leaves'', we formulate the idea that a leaf in the tree along with its path can already be seen as a bicluster. Each test $(\theta_j, f_j)$ can be seen as a binary question of the form $x_{f_j} > \theta_j$, where the possible outcomes are 1 (indicating yes) or 0 (indicating no). Consequently, a straightforward representation can be achieved by linearizing each decision tree in the forest, systematically applying each test, and evaluating the response of every object against all tests.\
With this new embedding, the decision trees distill the most representative tests, acting as selective filters for key features, while the entire forest collectively constitutes the comprehensive set of tests and their refinements, encompassing the full spectrum of feature interactions and distinctions.

### BicRF
 In our approach, we utilize a technique inspired by \textit{region growing}: region growing is a classical image segmentation technique that begins with an initial seed point and incrementally expands by adding neighboring pixels or regions that share similar properties, such as intensity or color, based on a predefined similarity criterion. Instead of pixels, we operate on objects within the data. The process starts with the two most similar objects, identified by the greatest intersection in terms of agreeing tests. From this initial pair, the region is expanded by progressively including, at each iteration, the object that exhibits the most similar test outcomes, ensuring that the growing cluster maintains homogeneity in terms of shared test results.\
For each feature in the extracted representation, we determine the number of tests conducted on that feature during the generation of the representation. The region-growing process is initiated by selecting the two most similar objects based on their representation. However, once the initial region is established, the features themselves must be incorporated into the decision-making process for expanding the region.

# Experiment Replication

**Setup**
-------------------------------------------
1. Matlab2023b
2. blaaa:

   a)  python >= 3
   
   b)  seaborn

**Input**
-------------------------------------------
The input to BicRF is any matrix that can be read via Matlab.

**Usage**
-------------------------------------------
_Mode 1_ : Use on a single matrix: 
    a)
    b)

_Mode 2_ : Replicate thesis experiment - toy dataset:

_Mode 3_ : Replicate thesis experiment - complex dataset:


**Replicate thesis complex datasets with GBic**
-------------------------------------------
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
-------------------------------------------
