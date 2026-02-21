{pkgs-unstable, ...}:

{
  home.packages = with pkgs-unstable; [
    # Python with comprehensive packages (Unstable - Latest Features & Fixes)
    python3  # Base Python interpreter for uv compatibility
    python3Packages.pip
    python3Packages.virtualenv
    
    # Core utilities
    # python3Packages.requests
    # python3Packages.pylint
    # python3Packages.black        # Code formatter
    # python3Packages.flake8       # Linting
    # python3Packages.pytest       # Testing framework
    # python3Packages.ipython      # Enhanced interactive Python
    # python3Packages.jupyter      # Jupyter notebook
    
    # # Scientific computing
    # python3Packages.numpy        # Numerical arrays
    # python3Packages.scipy        # Scientific computing
    # python3Packages.matplotlib   # Plotting
    # python3Packages.seaborn      # Statistical visualization
    # python3Packages.plotly       # Interactive plotting
    # python3Packages.sympy        # Symbolic mathematics
    
    # # Data science
    # python3Packages.pandas       # Data manipulation
    # python3Packages.scikit-learn # Machine learning
    # python3Packages.statsmodels  # Statistical modeling
    # python3Packages.networkx     # Network analysis
    # python3Packages.pillow       # Image processing
    # python3Packages.opencv4      # Computer vision
    
    # # Web development
    # python3Packages.flask        # Lightweight web framework
    # python3Packages.django       # Full-featured web framework
    # python3Packages.fastapi      # Modern API framework
    # python3Packages.jinja2       # Template engine
    # python3Packages.beautifulsoup4 # HTML parsing
    # python3Packages.lxml         # XML/HTML processing
    
    # # Database and storage
    # python3Packages.sqlalchemy   # SQL toolkit
    # python3Packages.psycopg2     # PostgreSQL adapter
    # python3Packages.redis        # Redis client
    # python3Packages.pymongo      # MongoDB client
    
    # # Async and networking
    # python3Packages.aiohttp      # Async HTTP client/server
    # python3Packages.websockets   # WebSocket support
    # python3Packages.paramiko     # SSH client
    
    # # Data formats
    # python3Packages.pyyaml       # YAML parser
    # python3Packages.toml         # TOML parser
    # python3Packages.openpyxl     # Excel files
    # python3Packages.h5py         # HDF5 files
    
    # # Development tools
    # python3Packages.rich         # Rich text and formatting
    # python3Packages.click        # Command line interfaces
    # python3Packages.tqdm         # Progress bars
    # python3Packages.joblib       # Parallel computing
    # python3Packages.schedule     # Job scheduling
  ];
}