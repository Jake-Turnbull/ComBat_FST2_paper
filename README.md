# ComBat_FST2_paper
A Python and MATLAB version of ComBat with edits described in association manuscript

The original code for neuro ComBat can be found [here](https://github.com/Jfortin1/ComBatHarmonization)

If you use the versions of ComBat or ComBat-M contained in this reposotiry, please cite the four papers described here:
    
      ComBat for multi-site DTI data:
      Jean-Philippe Fortin, Drew Parker, Birkan Tunc, Takanori Watanabe, Mark A Elliott, Kosha Ruparel, David R Roalf, Theodore D Satterthwaite, Ruben C Gur, Raquel E Gur, Robert T Schultz, Ragini Verma, Russell T Shinohara. Harmonization Of Multi-Site Diffusion Tensor Imaging Data. NeuroImage, 161, 149-170, 2017
      [Link](https://www.sciencedirect.com/science/article/abs/pii/S1053811917306948?via%3Dihub#!)
      
      ComBat for multi-site cortical thickness measurements:
      Jean-Philippe Fortin, Nicholas Cullen, Yvette I. Sheline, Warren D. Taylor, Irem Aselcioglu, Philip A. Cook, Phil Adams, Crystal Cooper, Maurizio Fava, Patrick J. McGrath, Melvin McInnis, Mary L. Phillips, Madhukar H. Trivedi, Myrna M. Weissman, Russell T. Shinohara. Harmonization of cortical thickness measurements across scanners and sites. NeuroImage, 167, 104-120, 2018
      [Link](https://www.sciencedirect.com/science/article/abs/pii/S105381191730931X)
      
      Original ComBat paper for gene expression array:
      W. Evan Johnson and Cheng Li, Adjusting batch effects in microarray expression data using empirical Bayes methods. Biostatistics, 8(1):118-127, 2007.
      [Link](https://academic.oup.com/biostatistics/article-abstract/8/1/118/252073?redirectedFrom=fulltext&login=false)
      
      Removing batch effects from purified plasma cell gene expression:
      Stein CK, Qu P, Epstein J, Buros A, Rosenthal A, Crowley J, Morgan G, Barlogie B. Removing batch effects from purified plasma cell gene expression microarrays with modified ComBat. BMC Bioinformatics. 2015 Feb 25;16:63. doi: 10.1186/s12859-015-0478-3. PMID: 25887219; PMCID: PMC4355992.
      [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC4355992/)



The Python scipt is standalone and a more updated version can also be found in: [DiagnoseHarmonise](https://github.com/Jake-Turnbull/HarmonisationDiagnostics)

The MATLAB folder contains the following files:

- aprior.m -> Calculate the hyperparameter a from feature and batch specific scale estimates (delta_hat)
- bprior.m -> Calculate the hyperparameter a from feature and batch specific scale estimates (delta_hat)
- combat.m -> The original MATLAB implementation of combat described in [Link](https://www.sciencedirect.com/science/article/abs/pii/S1053811917306948?via%3Dihub#!)
- combat_modified.m -> ComBat with additional functionality added (reference batch implementation, optional mean, scale corrections, option to skip EB, option to regress covariates)
- combat_modified_2.m -> Same as above but also returns a data structure with batch prior and hyperparameters stored
- inteprior.m 
- postvar.m -> Non-parametric EB implementation. Note, this version appears to be unstable and required more testing (forked directly from [Link](https://www.sciencedirect.com/science/article/abs/pii/S1053811917306948?via%3Dihub#!))
- itSol.m -> Iterative solution for the posterior estimates of the corrections
- postvar.m -> Find the posterior estimate for the variance correction
- postmean.m -> Find the posterior estimate for the mean correction
- Simulated_2.m -> Batch effect simulation script 
