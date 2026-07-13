query 50026 "Contract Milestones"
{

    elements
    {
        dataitem(Contract_Milestones; "Contract Milestones")
        {
            column(Contract_No; "Contract No") { }
            column(Milestone_Name; "Milestone Name") { }
            column(Milestone_Status; "Milestone Status") { }
            column(Milestone_Percentage; "Milestone Percentage") { }
            column(Amount_Paybale; "Amount Paybale") { }
            column(Deliverables; Deliverables) { }
            column(Start_Date; "Start Date") { }
            column(End_Date; "End Date") { }
            column(Unpaid_Milestone; "Unpaid Milestone") { }
            column(Duration; Duration) { }

            column(Paid_Milestone; "Paid Milestone") { }

        }
    }
}

