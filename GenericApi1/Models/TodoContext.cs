using Microsoft.EntityFrameworkCore;
using System.Diagnostics.CodeAnalysis;

namespace GenericApi1.Models
{
    public class TodoContext : DbContext
    {
        private string _connectionString = "Server=tcp:transact1.database.windows.net,1433;Initial Catalog=decowraps1;Persist Security Info=False;User ID=admin1;Password=Transact1.;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

        public TodoContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(_connectionString);
        }
        
        public TodoContext(DbContextOptions<TodoContext> options)
            : base(options)
        {
        }

        public DbSet<TodoItem> TodoItems { get; set; } = null!;
    }
}