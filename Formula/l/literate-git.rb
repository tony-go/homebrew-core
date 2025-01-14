class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://files.pythonhosted.org/packages/81/f4/19a33cccbd2b0b2d2c1d00a09e706358b332735efe918a3233fd920d0f6b/literategit-0.4.6.tar.gz"
  sha256 "2ea8161da2ebd67865fcf5c8131c842b509bcbdf8f47ba0cca273784265756bb"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c774d247edcde8b2fd8f94246e24019cd2a6538aea929c00504c04f6ecf4488"
    sha256 cellar: :any,                 arm64_ventura:  "1c37fc9a35aae080bd9714a93cb7837de7338f90b00946c975a63b069bc1ae74"
    sha256 cellar: :any,                 arm64_monterey: "a3a5892c6dc5981f64f85574e6db689674a989433cbaf253499b007bde1baf87"
    sha256 cellar: :any,                 sonoma:         "f555c0f79a61de641196fa16b2cc1d4263f57eab45880675f78101e32c643db8"
    sha256 cellar: :any,                 ventura:        "df9c5bcbbf5b6938a357f39142681f27ecd4eef97a7c026fc9870e0eec59c005"
    sha256 cellar: :any,                 monterey:       "0802f0ca68078efa7d6aeed6b26910455f78b6f331ecb9553e75945ded1ea1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fdad519d66ca762797d93bb47d0164f663f17090defd622c541d73e750e6fb4"
  end

  depends_on "libgit2"
  depends_on "python@3.12"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/74/89/a6bb59171d0bd5a3b19deb834ec29378a7c8e05bcb0a4dd4e5cb418ea03b/markdown2-2.4.13.tar.gz"
    sha256 "18ceb56590da77f2c22382e55be48c15b3c8f0c71d6398def387275e6c347a9f"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/f0/5e/6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bf/pygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
