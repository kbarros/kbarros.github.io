### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 2865e7b3-3122-4817-b043-736ca8caf508
# ╠═╡ show_logs = false
# This block loads the latest Sunny development branch from Github
begin
    import Pkg
    Pkg.activate(mktempdir()) 
    Pkg.add([
        Pkg.PackageSpec(name="Sunny", rev="main"),
		Pkg.PackageSpec(name="PlutoUI"),
    ])

	using Sunny, Plots, GLMakie, Formatting, PlutoUI
end

# ╔═╡ 27821cc3-79da-43cf-94b7-78484a6d61ac
md"""
# SU(3) Case Study: FeI$_{2}$

In this tutorial, we will walk through the process of calculating the dynamical properties of the compound FeI$_2$. This is an effective spin 1 material with strong single-ion anisotropy, making it a good candidate for treatment with generalized SU(3) spin dynamics.  Full details about the model can be found in reference [1]. [**LINK BROKEN** Give full URL?]

## Setting up the Crystal

Sunny has a number of facilities for specifying a crystal. If a CIF file is available, it can be loaded using `Crystal("file.cif")`. Here, instead, we will directly specify the lattice vectors and atom positions for a unit cell.
"""

# ╔═╡ d01da0e3-8ead-48aa-be2b-94e0a0fc7968
begin
	# Lattice vector lengths in angstroms
	a = b = 4.05012
	c = 6.75214
	# This a convenience method. Alternatively, lattice vectors could be specified as  columns of a 3x3 matrix.
	lat_vecs = lattice_vectors(a, b, c, 90, 90, 120) 
	# Locations of atoms as multiples of lattice vectors
	basis_vecs = [[0,0,0], [1/3, 2/3, 1/4], [2/3, 1/3, 3/4]] 
	# Type information is important for symmetry inference
	types = ["Fe", "I", "I"]

	full_crystal = Crystal(lat_vecs, basis_vecs; types)
	display(full_crystal)
end

# ╔═╡ 63b325d1-5c79-4251-89bf-03a262eb342e
md"""
Observe that Sunny inferred the space group `'P -3 m 1'`, corresponding to the international number 164. This is consistent with the table below, taken from reference [1] [**LINK?**].

$(PlutoUI.LocalResource("./fei2_table.png"))
"""

# ╔═╡ 749c46a8-19fd-4dba-80df-69f6a1eeb221
md"""
Alternatively, a `Crystal` can be constructed from a given spacegroup, here 164. The missing iodine atom will be correctly inferred from the first one by symmetry.
"""

# ╔═╡ d4c38d17-6685-4849-8193-1023976d10fb
let
	# Just include two atoms here
	types = ["Fe", "I"]
	basis_vecs = [[0,0,0], [1/3, 2/3, 1/4]]
	display(Crystal(lat_vecs, basis_vecs, 164; types))
end

# ╔═╡ 3dcce13c-d3b0-4efd-9f83-1c93a978e857
md"""
Our interest is the magnetic behavior of the Fe ions. We will restrict to this sublattice, while preserving symmetry information of the full FeI$_2$ crystal.
"""

# ╔═╡ d47cf2ba-7235-48bd-b3be-78c3fc034c55
begin
	FeI2_cryst = subcrystal(full_crystal, "Fe")
	display(FeI2_cryst)
end

# ╔═╡ 3774c7d0-d209-44e1-8263-5c14d9efce16
Sunny.view_crystal(full_crystal, 4.0)

# ╔═╡ af350eb6-3257-4458-b137-4cfc6c64eba1


# ╔═╡ Cell order:
# ╠═2865e7b3-3122-4817-b043-736ca8caf508
# ╟─27821cc3-79da-43cf-94b7-78484a6d61ac
# ╠═d01da0e3-8ead-48aa-be2b-94e0a0fc7968
# ╟─63b325d1-5c79-4251-89bf-03a262eb342e
# ╟─749c46a8-19fd-4dba-80df-69f6a1eeb221
# ╠═d4c38d17-6685-4849-8193-1023976d10fb
# ╟─3dcce13c-d3b0-4efd-9f83-1c93a978e857
# ╠═d47cf2ba-7235-48bd-b3be-78c3fc034c55
# ╠═3774c7d0-d209-44e1-8263-5c14d9efce16
# ╠═af350eb6-3257-4458-b137-4cfc6c64eba1
