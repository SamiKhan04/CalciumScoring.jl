### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ f914d5dc-9d93-49df-b05d-2a752ef8bc60
# ╠═╡ show_logs = false
begin
    using Pkg
    Pkg.activate("..")
    using Revise
    using PlutoUI
    using Test
    using CalciumScoring
    using Unitful: mm, mg
end

# ╔═╡ 01cb8e86-5072-42b6-b262-2412e3192ed4
@testset "Agatston" begin
    v1 = ones((4, 2, 2))
    v2 = zeros((4, 2, 2))
    vol = hcat(v1, v2) * 400
    spacing = [0.5, 0.5, 0.5]
    alg = Agatston()
    agatston_score, volume_score = score(vol, spacing, alg)
    @test agatston_score ≈ 16 && volume_score == 2
end

# ╔═╡ 6788b122-50b1-11ed-3603-c30ea99a0af2
@testset "Agatston Mass" begin
    v1 = ones((4, 2, 2))
    v2 = zeros((4, 2, 2))
    vol = hcat(v1, v2) * 400
    spacing = [0.5, 0.5, 0.5]
    alg = Agatston()
    mass_cal_factor = 0.00075
    agatston_score, volume_score, mass_score = score(vol, spacing, mass_cal_factor, alg)
    @test agatston_score ≈ 16 && mass_score ≈ 0.6
end

# ╔═╡ f73e5e28-daa5-4a14-8493-9d5cad0c55ce
@testset "Agatston, various kVs" begin
	hus = [260, 280, 310, 400]
	kVs = [135, 120, 100, 80]
	scores = []
	for i in 1:4
		arr = [
			0 hus[i] hus[i] hus[i] 0 0 0
			0 hus[i] hus[i] hus[i] 0 0 0
			0 hus[i] hus[i] hus[i] 0 0 0
			0 hus[i] hus[i] hus[i] 0 0 0
		]
		arr = cat(arr, arr, dims=3)
		scr, _ = score(arr, [0.5, 0.5, 0.5], Agatston(); kV=kVs[i])
		push!(scores, scr)
	end
	@test unique(scores) == [12]
end

# ╔═╡ 5a89e57e-e82f-41f1-ab35-eec72c647ebf
@testset "Agatston Unitful" begin
    v1 = ones((4, 2, 2))
    v2 = zeros((4, 2, 2))
    vol = hcat(v1, v2) * 400
    spacing = [0.5, 0.5, 0.5]mm
    alg = Agatston()
    agatston_score, volume_score = score(vol, spacing, alg)
    @test agatston_score ≈ 16 && volume_score == 2mm^3
end

# ╔═╡ fbc3acff-432a-48f6-b4d2-5be117c420d3
@testset "Agatston Mass" begin
    v1 = ones((4, 2, 2))
    v2 = zeros((4, 2, 2))
    vol = hcat(v1, v2) * 400
    spacing = [0.5, 0.5, 0.5]mm
    alg = Agatston()
    mass_cal_factor = 0.00075mg / mm^3
    agatston_score, volume_score, mass_score = score(vol, spacing, mass_cal_factor, alg)
    @test agatston_score ≈ 16 && mass_score ≈ 0.6mg
end

# ╔═╡ Cell order:
# ╠═f914d5dc-9d93-49df-b05d-2a752ef8bc60
# ╠═01cb8e86-5072-42b6-b262-2412e3192ed4
# ╠═6788b122-50b1-11ed-3603-c30ea99a0af2
# ╠═f73e5e28-daa5-4a14-8493-9d5cad0c55ce
# ╠═5a89e57e-e82f-41f1-ab35-eec72c647ebf
# ╠═fbc3acff-432a-48f6-b4d2-5be117c420d3
