using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace TestSvc.Controllers
{
    [Route("/")]
    [ApiController]
    public class ApiController : ControllerBase
    {
        [HttpGet]
        public ActionResult<NameResponse> Get()
        {
            return new NameResponse()
            {
                FooBar = "dotnetcore",
                TimeStamp = DateTime.UtcNow,
                Pod = Environment.GetEnvironmentVariable("HOSTNAME"),
            };
        }
    }

    public class NameResponse
    {
        public string FooBar { get; set; }
        public DateTime TimeStamp { get; set; }
        public string Pod { get; set; }
    }
}
