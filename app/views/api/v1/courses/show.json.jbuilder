json.course do
  json.id @course.id
  json.name @course.name
  json.lecturer @course.lecturer
  json.description @course.description
  json.chapters @course.chapters.each do |chapter|
                  json.id chapter.id
                  json.name chapter.name
                  json.units chapter.units.each do |unit|
                    json.id unit.id
                    json.name unit.name
                    json.description unit.description
                    json.content unit.content
                  end
                end
end