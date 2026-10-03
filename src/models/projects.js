import db from "./db.js";

const getAllProjects = async () => {
  const query = `
    SELECT
      service_project.project_id,
      service_project.title,
      service_project.description,
      TO_CHAR(service_project.project_date, 'FMMonth FMDD, YYYY') AS project_date,
      organization.name AS organization_name
    FROM public.service_project
    INNER JOIN public.organization
      ON service_project.organization_id = organization.organization_id
    ORDER BY service_project.project_date, service_project.title;
  `;

  const result = await db.query(query);

  return result.rows;
};

const getUpcomingProjects = async (number_of_projects) => {
  const query = `
    SELECT
      service_project.project_id,
      service_project.title,
      service_project.description,
      TO_CHAR(service_project.project_date, 'FMMonth FMDD, YYYY') AS date,
      service_project.location,
      service_project.organization_id,
      organization.name AS organization_name
    FROM public.service_project
    INNER JOIN public.organization
      ON service_project.organization_id = organization.organization_id
    WHERE service_project.project_date >= CURRENT_DATE
    ORDER BY service_project.project_date ASC, service_project.title ASC
    LIMIT $1;
  `;

  const queryParams = [number_of_projects];
  const result = await db.query(query, queryParams);

  return result.rows;
};

const getProjectDetails = async (projectId) => {
  const query = `
    SELECT
      service_project.project_id,
      service_project.title,
      service_project.description,
      TO_CHAR(service_project.project_date, 'FMMonth FMDD, YYYY') AS date,
      service_project.location,
      service_project.organization_id,
      organization.name AS organization_name
    FROM public.service_project
    INNER JOIN public.organization
      ON service_project.organization_id = organization.organization_id
    WHERE service_project.project_id = $1;
  `;

  const queryParams = [projectId];
  const result = await db.query(query, queryParams);

  return result.rows.length > 0 ? result.rows[0] : null;
};

const getProjectsByOrganizationId = async (organizationId) => {
  const query = `
    SELECT
      project_id,
      organization_id,
      title,
      description,
      project_date
    FROM public.service_project
    WHERE organization_id = $1
    ORDER BY project_date;
  `;

  const queryParams = [organizationId];
  const result = await db.query(query, queryParams);

  return result.rows;
};

export {
  getAllProjects,
  getUpcomingProjects,
  getProjectDetails,
  getProjectsByOrganizationId,
};
