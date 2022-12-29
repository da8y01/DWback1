namespace GenericApi1.Models
{
    public class TodoItemDTO
    {
        public long Id { get; set; }
        public string? Name { get; set; }
        //public bool IsComplete { get; set; }
        public int IsComplete { get; set; }
    }
}