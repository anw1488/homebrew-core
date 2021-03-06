class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/99/4f/d2ea0eb3b200093648c9ea3c81bd532388cb46d2734ec2f83bbab4d765f8/ccm-2.8.2.tar.gz"
  sha256 "ffb8520756e2a2630bb8eed804c1d9cfcc9e09faf12840c98ff7f24a59665bd5"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "137b8e5c4eb668dd154efa1cc0115b5ac39cfc312ed724949369067c2d8a2577" => :sierra
    sha256 "6a38a0d0cc87fe117cb41ba7f83e0ff7a714bfaca5318ff55ef4f3fa3cd78115" => :el_capitan
    sha256 "6a38a0d0cc87fe117cb41ba7f83e0ff7a714bfaca5318ff55ef4f3fa3cd78115" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[PyYAML six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
