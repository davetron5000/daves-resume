require "resume"
require "markdown"
require "serializer"
require "yaml"

include Resume

contact_info = ContactInfo.new
contact_info.name = "David Copeland"
contact_info.email = "davidcopeland@naildrivin5.com"
contact_info.address = Address.new
contact_info.address.street = "1217 N St, NW, #T-01"
contact_info.address.city = "Washington"
contact_info.address.state = "DC"
contact_info.address.zip = "20005"
contact_info.phone = "202-558-2131"

core = ResumeCore.new
core.contact_info=contact_info
core.headline = "A results-oriented technical leader with proven success designing, developing, and deploying enterprise software systems"
core.summary = "Proven abilities as a developer, leader, and mentor.  Produces high-quality deliverables through pragmatic, results-driven best practices.  Deep technical expertise with enterprise Java, object-oriented design, and software development processes.  Has lead successful teams as an architect, technical lead, and department manager.  History of improving the quality of every project, team, and deliverable by balancing business, user, and technical needs."

resume = Resume.new()
resume.core = core

gliffy = Job.new
gliffy.name = "Gliffy.com"
gliffy.date_range = DateRange.new
gliffy.date_range.start_date = Date.civil(2008,4,1)
gliffy.date_range.end_date = Date.civil(2008,10,15)
gliffy.location = "San Francisco, CA"
gliffy.positions = [ Position.new ]
gliffy.positions[0].title = "Senior Software Engineer (Contract, Telecommute)"
gliffy.positions[0].date_range = gliffy.date_range
gliffy.positions[0].description = "Design and implement REST-based developer API in Java/J2EE and PHP for integrating flagship product (a diagramming tool) into other 'Web 2.0' applications.  Advise on technical architecture and deployment issues.  Provide developer documentation and other support materials.  Additional Java software design and development."
gliffy.positions[0].achievments = Array.new
gliffy.positions[0].achievments << "Designed a REST-based web service API for integrating Gliffy into any web-enabled software.  This opens the door to increased marketshare, new products, and increased revenue"
gliffy.positions[0].achievments << "Created a MediaWiki plugin for Gliffy's product that they can sell support for, opening an additional revenue path for the company"
gliffy.positions[0].achievments << "Refactored JDBC/SQL-based data layer into O/R mapping layer using Java Persistence and Hibernate, thus reducing the maintenance and enhancement costs of Gliffy's flagship product"
gliffy.positions[0].achievments << "Created a testbed for Gliffy's flash-based application as well as the Developer API that made refactoring possible as well as reduced the cost of maintenance."

resume.experience << gliffy

asu = Education.new
asu.name = "Arizona State University"
asu.degree = "Master of Science"
asu.year_graduated = 1997
asu.major = "Computer Science"
asu.other_info = "Thesis: 'A Methodology for Software Verification and Validation Process Improvement'"

vt = Education.new
vt.name = "Virginia Tech"
vt.degree = "Bachelor of Science"
vt.year_graduated = 1996
vt.major = "Computer Science"

resume.education << asu
resume.education << vt

skillset = SkillSet.new
skillset.skills = Hash.new
skillset.skills[:languages] = Array.new
skillset.skills[:languages] << Skill.new("Java",:expert)
skillset.skills[:languages] << Skill.new("PERL",:expert)
skillset.skills[:languages] << Skill.new("C",:expert)
skillset.skills[:languages] << Skill.new("SQL",:expert)
skillset.skills[:languages] << Skill.new("XML",:intermediate)
skillset.skills[:languages] << Skill.new("PHP",:intermediate)
skillset.skills[:languages] << Skill.new("Ruby",:intermediate)
skillset.skills[:languages] << Skill.new("HTML",:intermediate)
skillset.skills[:languages] << Skill.new("CSS",:intermediate)
skillset.skills[:languages] << Skill.new("C++",:intermediate)

skillset.skills[:apis] = Array.new
skillset.skills[:apis] << Skill.new("J2EE/JavaEE",:expert)
skillset.skills[:apis] << Skill.new("EJB3",:expert)
skillset.skills[:apis] << Skill.new("Servlets",:expert)
skillset.skills[:apis] << Skill.new("Java Persistence",:expert)
skillset.skills[:apis] << Skill.new("JDBC",:expert)
skillset.skills[:apis] << Skill.new("Hibernate",:intermediate)
skillset.skills[:apis] << Skill.new("Swing",:expert)
skillset.skills[:apis] << Skill.new("JAXB",:intermediate)
skillset.skills[:apis] << Skill.new("HTTP/REST",:intermediate)
skillset.skills[:apis] << Skill.new("TestNG",:intermediate)
skillset.skills[:apis] << Skill.new("JUnit",:intermediate)
skillset.skills[:apis] << Skill.new("JSP",:intermediate)
skillset.skills[:apis] << Skill.new("JMS",:intermediate)
skillset.skills[:apis] << Skill.new("JavaHelp",:intermediate)
skillset.skills[:apis] << Skill.new("Seam",:novice)
skillset.skills[:apis] << Skill.new("Spring",:novice)
skillset.skills[:apis] << Skill.new("Struts",:novice)
skillset.skills[:apis] << Skill.new("FLEX",:novice)
skillset.skills[:apis] << Skill.new("SOA",:novice)
skillset.skills[:apis] << Skill.new("Ajax",:novice)
skillset.skills[:apis] << Skill.new("OpenID",:novice)

resume.skills = skillset

chrisk = Reference.new
chrisk.name = "Chris Kohlhardt"
chrisk.company = "Gliffy"
chrisk.relationship = "Manager"
chrisk.email = "chrisk@gliffy.com"

mike = Reference.new
mike.name = "Mike Gercken"
mike.company = "Provident Analysis Corporation"
mike.relationship = "Manager"
mike.email = "mgercken@pacplanetcom"

resume.references << chrisk
resume.references << mike

resume.to_markdown("README.markdown")

Serializer.store("resume_dir",resume)
