import type { ODataRecord } from './bcClient.js'

function value(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const candidate = row[key]
    if (candidate !== undefined && candidate !== null && String(candidate).trim()) {
      return String(candidate).trim()
    }
  }
  return ''
}

function isTrue(candidate: unknown) {
  return candidate === true || candidate === 1 || String(candidate).trim().toLowerCase() === 'true'
}

/**
 * HR Training Applications."Course Title" is misleadingly named in BC: its
 * TableRelation points to HR Training Courses."Course Code". Keep the course
 * code as the submitted value and use "Course Tittle" only as its label.
 */
export function trainingCourseLookupOption(row: ODataRecord) {
  if (isTrue(row.Closed) || isTrue(row.IndividualCourse ?? row.Individual_Course)) {
    return null
  }

  const courseCode = value(row, ['CourseCode', 'Course_Code'])
  if (!courseCode) return null

  const courseTitle =
    value(row, ['CourseTittle', 'CourseTitle', 'Course_Title', 'CourseName']) || courseCode

  return {
    value: courseCode,
    label: courseTitle,
    meta: { courseTitle },
  }
}

function normalizedCourseValue(candidate: unknown) {
  return String(candidate ?? '').trim().replace(/\s+/g, ' ').toLocaleLowerCase()
}

/**
 * Accept either the code selected by the current portal or a title submitted by
 * an older/cached portal build, then return the matching BC lookup option.
 */
export function trainingCourseOptionForBc(candidate: unknown, rows: ODataRecord[]) {
  const normalizedCandidate = normalizedCourseValue(candidate)
  if (!normalizedCandidate || normalizedCandidate === '__other__') return null

  return (
    rows
      .map((row) => trainingCourseLookupOption(row))
      .filter((option): option is NonNullable<typeof option> => Boolean(option))
      .find(
        (option) =>
          normalizedCourseValue(option.value) === normalizedCandidate ||
          normalizedCourseValue(option.label) === normalizedCandidate,
      ) ?? null
  )
}

/** "__OTHER__" belongs only to the portal assessment companion record. */
export function trainingCourseCodeForBc(candidate: unknown) {
  const courseCode = String(candidate ?? '').trim()
  return courseCode === '__OTHER__' ? '' : courseCode
}
