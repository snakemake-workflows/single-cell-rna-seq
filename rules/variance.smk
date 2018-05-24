rule hvg:
    input:
        "analysis/normalized.rds"
    output:
        var="analysis/variance.rds",
        hvg="tables/hvg.tsv",
        hvg_expr_dist="plots/hvg-expr-dists.svg",
        mean_vs_variance="plots/mean-vs-variance.svg"
    params:
        use_spikes=config["variance"]["use-spikes"]
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg.R"


rule correlation:
    input:
        hvg="tables/hvg.tsv",
        rds="analysis/normalized.rds"
    output:
        corr="tables/hvg-correlations.tsv",
        graph="plots/hvg-clusters.svg",
        heatmap="plots/hvg-corr-heatmap.svg",
        pca="plots/hvg-corr-pca.svg"
    conda:
        "../envs/eval.yaml"
    script:
        "../scripts/hvg-correlation.R"
