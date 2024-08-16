# BicRF

This thesis will focus on developing a Random Forest-based approach for the biclustering problem.
Biclustering is usually defined as the simultaneous clustering of both rows andß columns of a given data matrix. Given a data matrix, biclustering techniques aim to extract subsets of rows that exhibit ``similar'' behavior in a subset of columns (and vice versa). Biclustering was first devised to analyze the expression of genes in microarray data. However, it has recently been used in various applications ranging from clickstream data analysis to recommender systems and computer vision (e.g., facial expression recognition, motion and plane estimation, and region-based correspondences).\\

The relevant literature on biclustering offers a wealth of techniques that focus on different aspects such as the efficiency of the biclustering procedures, interpretability of the biclusters computed by the approach, and so forth. Several such techniques take inspiration from clustering methods and adapt them to biclustering, for example by iteratively performing clustering on rows and columns.\\
This thesis will explore a novel class of biclustering methods based on Random Forests (RF). RFs have been extensively investigated for classification and regression and shown to compete well with the most effective approaches, such as Support Vector Machines or Neural Networks. However, in other pattern recognition scenarios, such as clustering, RFs have received less attention, and their potential is far from being completely understood. There is a notable absence of RF-based approaches for biclustering in the literature, which is the main focus of this work. In particular, we define an RF-based representation that binarizes the initial complex data, to favor the extraction of hidden biclusters, and we propose BicRF, a novel algorithm that exploits the RF representation, selecting objects and features agreeing on the same tests.\\

While evaluating the performances of our approach on synthetic benchmarks, we took into consideration two different measures: the representativeness of such an embedding to analyze the degree to which we can recover the hidden information and the performances of BicRF, compared with the state of the art in biclustering. 


## The Algorithm
We derive the initial representation from a random forest, which involves linearizing decision trees and organizing test outcomes into a binary matrix. This matrix serves as the foundation for the BicRF algorithm, which is designed to extract biclusters from the representation. BicRF operates by initiating regions based on the most similar objects and expanding these regions through a process inspired by region growing, where objects are added based on the percentage of agreeing tests. We further refine our approach using BicRFOpt, which allows for the optimization of bicluster quality by evaluating multiple thresholds and selecting the one that yields the best result. This chapter details the steps involved in each phase of the methodology, from initial representation to final bicluster extraction, providing a comprehensive framework for understanding and applying BicRF in practical scenarios.


### RF Training
The training phase was done employing the Matlab library from [this paper]([http://example.com](https://profs.scienze.univr.it/~bicego/papers/2020_ICPR_On_learning_Random.pdf)). The baseline approach of the library is the classic Random Forest model for classification. In this method, standard decision trees, such as CART or C4.5, are trained using two classes: the positive class, which consists of the points to be clustered, and a synthetically generated negative class. The negative class is generated through random sampling from the product of the empirical marginal distributions of the observed data. By sampling in this manner, the inter-feature dependencies are effectively removed. The size of the negative class is matched to that of the positive class, ensuring balance in the training data.\\
An alternative approach involves the use of Extremely Randomized Trees (ERTs). In the extreme version implemented in the referenced library, the feature used for splitting at each node is selected entirely at random, as is the splitting threshold. This technique introduces a higher level of randomness into the training process, further diversifying the decision trees within the forest. As a general setup we train a forest of 100 trees, each with a maximum depth of 5. 

### Representation Extraction
Relying on the idea that ''given a tree, we can aggregate the different objects into groups by looking at the path they are following from the root to the leaves'', we formulate the idea that a leaf in the tree along with its path can already be seen as a bicluster. Each test $(\theta_j, f_j)$ can be seen as a binary question of the form $x_{f_j} > \theta_j$, where the possible outcomes are 1 (indicating yes) or 0 (indicating no). Consequently, a straightforward representation can be achieved by linearizing each decision tree in the forest, systematically applying each test, and evaluating the response of every object against all tests.\\
With this new embedding, the decision trees distill the most representative tests, acting as selective filters for key features, while the entire forest collectively constitutes the comprehensive set of tests and their refinements, encompassing the full spectrum of feature interactions and distinctions.

### BicRF
 In our approach, we utilize a technique inspired by \textit{region growing}: region growing is a classical image segmentation technique that begins with an initial seed point and incrementally expands by adding neighboring pixels or regions that share similar properties, such as intensity or color, based on a predefined similarity criterion. Instead of pixels, we operate on objects within the data. The process starts with the two most similar objects, identified by the greatest intersection in terms of agreeing tests. From this initial pair, the region is expanded by progressively including, at each iteration, the object that exhibits the most similar test outcomes, ensuring that the growing cluster maintains homogeneity in terms of shared test results.\\
For each feature in the extracted representation, we determine the number of tests conducted on that feature during the generation of the representation. The region-growing process is initiated by selecting the two most similar objects based on their representation. However, once the initial region is established, the features themselves must be incorporated into the decision-making process for expanding the region.
