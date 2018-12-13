using System;
using System.Collections.Generic;
using System.Text;

namespace PrizeClaimScanner.Model
{
    public enum Gender
    {
        None,
        Male,
        Female
    }

    public enum Education
    {
        None,
        DidNotFinishHighSchool,
        GraduatedHighSchoolOrGED,
        SomeCollege,
        GradutedCollege
    }

    public enum HouseholdIncome
    {
        None,
        Under20K,
        From20KTo35K,
        From35KTo50K,
        From50KTo75K,
        Over75K
    }
}
