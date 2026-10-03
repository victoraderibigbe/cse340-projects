-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- ========================================
-- Service Project Table
-- ========================================
CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    project_date DATE NOT NULL,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id)
);

-- ========================================
-- Insert sample data: Service Projects
-- ========================================
INSERT INTO service_project (title, description, project_date, organization_id)
VALUES
('Community Garden Build', 'Build raised garden beds for a neighborhood community garden.', '2026-10-10', 1),
('Accessible Ramp Construction', 'Construct an accessible ramp for a local community center.', '2026-10-17', 1),
('Neighborhood Playground Repair', 'Repair and refresh equipment at a neighborhood playground.', '2026-10-24', 1),
('Rainwater Collection Workshop', 'Install rainwater collection systems and teach water conservation.', '2026-10-31', 1),
('Community Center Renovation', 'Paint and repair shared spaces at a community center.', '2026-11-07', 1),
('Harvest Donation Day', 'Harvest fresh produce for donation to local food pantries.', '2026-10-11', 2),
('School Garden Planting', 'Plant vegetables and herbs with students at a local school.', '2026-10-18', 2),
('Composting Education Fair', 'Teach residents how to compost household and garden waste.', '2026-10-25', 2),
('Urban Orchard Care', 'Care for and maintain fruit trees in an urban orchard.', '2026-11-01', 2),
('Seed Distribution Event', 'Prepare and distribute seed packets to neighborhood gardeners.', '2026-11-08', 2),
('Food Pantry Stocking', 'Sort and stock donated food at a local food pantry.', '2026-10-12', 3),
('Senior Center Support', 'Assist staff and residents with activities at a senior center.', '2026-10-19', 3),
('Clothing Donation Drive', 'Collect, sort, and distribute clothing to families in need.', '2026-10-26', 3),
('River Cleanup', 'Remove litter from a local riverbank and surrounding paths.', '2026-11-02', 3),
('Holiday Assistance Program', 'Prepare care packages for families during the holiday season.', '2026-11-09', 3);

-- ========================================
-- Service Project Category Table
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- ========================================
-- Service Project/Category Join Table
-- ========================================
CREATE TABLE service_project_category (
    project_id INTEGER NOT NULL
        REFERENCES service_project(project_id)
        ON DELETE CASCADE,

    category_id INTEGER NOT NULL
        REFERENCES category(category_id)
        ON DELETE CASCADE,

    PRIMARY KEY (project_id, category_id)
);

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (name)
VALUES
('Community Development'),
('Food Security'),
('Environmental Stewardship'),
('Education and Outreach');

-- ========================================
-- Associate Service Projects with Categories
-- ========================================
INSERT INTO service_project_category (project_id, category_id)
SELECT project.project_id, category.category_id
FROM (
    VALUES
        ('Community Garden Build', 'Community Development'),
        ('Community Garden Build', 'Environmental Stewardship'),

        ('Accessible Ramp Construction', 'Community Development'),

        ('Neighborhood Playground Repair', 'Community Development'),

        ('Rainwater Collection Workshop', 'Environmental Stewardship'),
        ('Rainwater Collection Workshop', 'Education and Outreach'),

        ('Community Center Renovation', 'Community Development'),

        ('Harvest Donation Day', 'Food Security'),
        ('Harvest Donation Day', 'Environmental Stewardship'),

        ('School Garden Planting', 'Food Security'),
        ('School Garden Planting', 'Education and Outreach'),

        ('Composting Education Fair', 'Environmental Stewardship'),
        ('Composting Education Fair', 'Education and Outreach'),

        ('Urban Orchard Care', 'Food Security'),
        ('Urban Orchard Care', 'Environmental Stewardship'),

        ('Seed Distribution Event', 'Food Security'),

        ('Food Pantry Stocking', 'Food Security'),

        ('Senior Center Support', 'Community Development'),

        ('Clothing Donation Drive', 'Community Development'),

        ('River Cleanup', 'Environmental Stewardship'),

        ('Holiday Assistance Program', 'Community Development'),
        ('Holiday Assistance Program', 'Food Security')
) AS project_categories(project_title, category_name)
INNER JOIN service_project AS project
    ON project.title = project_categories.project_title
INNER JOIN category
    ON category.name = project_categories.category_name;

-- Add location column to service_project table
ALTER TABLE service_project ADD COLUMN location VARCHAR(255);