# db/seeds.rb — Relationship Milestones demo data
# Run: bin/rails db:seed

puts "Seeding demo relationship..."

rel = Relationship.find_or_create_by!(title: "Our story") do |r|
  r.mode          = "couple"
  r.status        = "active"
  r.chapter_number = 1
  r.began_on      = 14.months.ago.to_date
end

milestones_data = [
  {
    title:             "The night we actually talked",
    occurred_on:       14.months.ago.to_date,
    milestone_type:    "first",
    description:       "We had met at that gallery opening three weeks before, briefly. This was different — we ended up on the fire escape until 2am.",
    my_perspective:    "I kept thinking the conversation would run dry. It never did.",
    emotional_tags:    [ "joy", "tenderness", "vulnerability" ],
    emotional_intensity: 7
  },
  {
    title:             "First trip — the drive to the coast",
    occurred_on:       11.months.ago.to_date,
    milestone_type:    "first",
    description:       "We drove four hours with no planned route. Found a small guesthouse with a creaking floor and ate at the only open café.",
    my_perspective:    "The drive taught me how comfortable silence could be with someone.",
    emotional_tags:    [ "joy", "stability", "tenderness" ],
    emotional_intensity: 6
  },
  {
    title:             "The running joke about the map",
    occurred_on:       10.months.ago.to_date,
    milestone_type:    "funny",
    description:       "We got lost on the coast trip and blamed each other's navigation for twenty minutes. Now 'you're the map' is what we say when either of us makes a mistake.",
    emotional_tags:    [ "humor", "joy" ],
    emotional_intensity: 3
  },
  {
    title:             "First real argument",
    occurred_on:       9.months.ago.to_date,
    milestone_type:    "conflict",
    description:       "A disagreement about priorities escalated into something older and larger than either of us expected.",
    my_perspective:    "I said things that were more about fear than frustration. I didn't realize that until later.",
    partner_perspective: "She felt unheard at a time when she needed acknowledgment, not solutions.",
    repair_notes:      "We talked for two hours the next morning. No conclusions, just listening. That helped more than any resolution.",
    emotional_tags:    [ "tension", "vulnerability", "grief" ],
    emotional_intensity: 9
  },
  {
    title:             "Learning her morning rhythm",
    occurred_on:       8.months.ago.to_date,
    milestone_type:    "growth",
    description:       "I stopped trying to have meaningful conversations before 9am. She stopped apologizing for needing silence.",
    emotional_tags:    [ "growth", "stability" ],
    emotional_intensity: 4
  },
  {
    title:             "Moving in together",
    occurred_on:       5.months.ago.to_date,
    milestone_type:    "transition",
    description:       "We merged two very different households into one apartment. The first two weeks were an experiment in tolerance.",
    my_perspective:    "I underestimated how much space I needed. She underestimated how attached I was to the wrong furniture.",
    emotional_tags:    [ "growth", "tension", "stability" ],
    emotional_intensity: 7
  },
  {
    title:             "The week I was away — checking in across distance",
    occurred_on:       3.months.ago.to_date,
    milestone_type:    "growth",
    description:       "Work travel, ten days. We found a new rhythm for staying connected — less frequent but more intentional.",
    emotional_tags:    [ "longing", "growth", "tenderness" ],
    emotional_intensity: 5
  },
  {
    title:             "Talked about the future for the first time",
    occurred_on:       6.weeks.ago.to_date,
    milestone_type:    "transition",
    description:       "Not plans. Just the fact that we both assumed there would be one, and said it out loud.",
    my_perspective:    "It felt surprisingly calm. Like confirming something that had already been decided.",
    emotional_tags:    [ "stability", "tenderness", "growth" ],
    emotional_intensity: 6
  }
]

milestones_data.each do |attrs|
  rel.milestones.find_or_create_by!(title: attrs[:title]) do |m|
    m.assign_attributes(attrs)
  end
end

# Reflections
[
  { prompt_type: "most_myself", content: "The night on the fire escape, honestly. And the drive, when we'd been silent for forty minutes and neither of us felt the need to fill it." },
  { prompt_type: "patterns",   content: "I tend to retreat when I'm overwhelmed rather than say I'm overwhelmed. She tends to interpret silence as distance. We've named this now, which helps." }
].each do |attrs|
  rel.reflections.find_or_create_by!(prompt_type: attrs[:prompt_type]) do |r|
    r.content = attrs[:content]
  end
end

puts "Done. Relationship: #{rel.title}, #{rel.milestones.count} milestones, #{rel.reflections.count} reflections."
