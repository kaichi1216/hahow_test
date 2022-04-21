json.course do
  json.id @course.id
  json.name @course.name
  json.lecturer @course.lecturer
  json.description @course.description
  json.chapters @chapters.each do |chapter|
                  json.id chapter.id
                  json.name chapter.name
                  json.position chapter.position
                  json.units chapter.units.each do |unit|
                    json.id unit.id
                    json.name unit.name
                    json.position unit.position
                    json.description unit.description
                    json.content unit.content
                  end
                end
end