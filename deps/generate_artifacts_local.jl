
using Pkg.Artifacts

# Helper functions used to copy related files to artifact and update Artifacts.toml
# While part of the job is done by the helper, some manual editing is still required.

const artifacts_toml = joinpath(dirname(dirname(@__FILE__)), "Artifacts.toml")
const fake_url = "https://upload_generated_artifact_archive_file_to_this_url.tar.gz"
const artifacts_name = "plotly-artifacts"

function create_artifacts_from_plotly_dist(dist_path::String, 
        archive_artifact_path::String="plotly.js-artifacts.tar.gz";
        verbose=true)
    new_artifact_hash = create_artifact() do artifact_dir
        selected_name = ["plotly.min.js", "plot-schema.json"]
        map(selected_name) do name
            cp(joinpath(dist_path, name), joinpath(artifact_dir, name))
        end
    end
    
    if isfile(archive_artifact_path)
        rm(archive_artifact_path)
    end
    new_archive_hash = archive_artifact(new_artifact_hash, archive_artifact_path)

    old_artifact_hash = artifact_hash(artifacts_name, artifacts_toml)
    old_download = artifact_meta("plotly-artifacts", artifacts_toml)["download"][1]
    old_archive_hash = old_download["sha256"]
    old_url = old_download["url"]
    bind_artifact!(artifacts_toml, artifacts_name, new_artifact_hash; download_info = [
        (fake_url, new_archive_hash)
    ], force=true)

    if verbose
        println("Artifact hash: $old_artifact_hash => $new_artifact_hash")
        println("Archive hash: $old_archive_hash => $new_archive_hash")
        println("Download url: $old_url => $fake_url")
        
        println("\nEdit $fake_url to true value!")
    end
end
