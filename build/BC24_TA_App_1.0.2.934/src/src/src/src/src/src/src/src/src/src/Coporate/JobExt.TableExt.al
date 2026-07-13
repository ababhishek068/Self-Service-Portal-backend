tableextension 50025 JobExt extends Job
{
    fields
    {
        field(50000; "Workplan No"; Code[20])
        {
            TableRelation = Workplan."Workplan Code.";
        }
        field(50001; "Workplan Activity Code"; Code[20])
        {
            TableRelation = "Workplan Activities"."Activity Code" where("Procurement Workplan Code" = field("Workplan No"), "Activity Type" = filter(Project));
            trigger OnValidate()
            var
                WorkPlanActivity: Record "Workplan Activities";
            begin
                WorkPlanActivity.reset;
                WorkPlanActivity.setrange("Procurement Workplan Code", "Workplan Activity Code");
                WorkPlanActivity.setrange("No.", "Workplan Activity Code");
                if WorkPlanActivity.find('-') then begin
                    Description := WorkPlanActivity."Activity Description";
                    "Global Dimension 1 Code" := WorkPlanActivity."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := WorkPlanActivity."Global Dimension 2 Code";

                end;

            end;
        }
        field(50002; "Type of Project"; Option)
        {
            OptionMembers = "","Research","Development","Consultancy";
        }
        field(50003; "Source of Funds"; Code[20])
        {
            FieldClass = flowfield;
            CalcFormula = lookup("Workplan Activities"."Source of Activity Fund" where("Procurement Workplan Code" = field("Workplan No"), "No." = field("Workplan Activity Code")));

        }
        field(50004; "Global Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DONOR'));

        }
        field(50005; "Global Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('PROJECT'));

        }
        field(50006; "Global Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('STATION'));

        }
        field(50007; "Project Objective"; Code[100]) { }
        field(50008; "Project Location"; code[100]) { }
        field(50058; "Implementing Agency"; code[100]) { }
        field(50009; "Programme"; code[100]) { }
        field(50010; "Type of Study"; option)
        {
            OptionMembers = "On-station experiment","Survey","Other";
        }
        field(50011; "Main Achievement"; Text[250]) { }
        field(50012; "Challenges and Constraints Q1"; Text[150]) { }
        field(50013; "Challenges and Constraints Q2"; Text[150]) { }
        field(50014; "Challenges and Constraints Q3"; Text[150]) { }
        field(50015; "Challenges and Constraints Q4"; Text[150]) { }
        field(50016; "Continuity"; Text[150]) { }
        field(50017; "Project Duration (Years)"; Integer) { }
        field(50018; "Project Duration Type"; Option)
        {
            OptionMembers = Years,Months,Weeks,Days;
        }
        field(50019; "Funding Agency"; text[200]) { }
        field(50020; "Project Title"; text[200]) { }

        field(50021;Q1;Decimal){}
        field(50022;Q2;Decimal){}
        field(50023;Q3;Decimal){}
        field(50024;Q4;Decimal){}
        field(50025;Y1;Decimal){}
        field(50026;Y2;Decimal){}
        field(50027;Y3;Decimal){}
        field(50028;Y4;Decimal){}
        field(50029;Y5;Decimal){}
        field(50030;Target;Decimal){}
        field(50031;Achievement;Decimal){}
        field (50032;"Target percentage";Decimal){}
        field (50033;"Actual Perc";Decimal){}


    }
}