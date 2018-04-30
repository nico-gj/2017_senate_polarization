# Visualizing Partisanship in US Senate Voting

## Introduction

While increased partisanship has long been a problem in Washington, the last 10 years have taken the issue to a whole new level. Parties radicalized under Obama's presidency, and the election of Donald Trump in 2016 exacerbated tensions between Democrats and Republicans. A number of research has found record levels of partisanship in Congress this past year ([VoteView](https://voteview.com/) has tracked partisanship in Congress since 1992 using the DW-NOMINATE procedure and recently called the 114th Congress ["the most polarized [...] since the early 20th Century"](https://voteviewblog.com/2016/12/18/the-end-of-the-114th-congress/)).

Using the publicly available Roll Call Votes, this project visualizes this years ideological clusters by plotting all US Senators on the first 2 principle components of all votes. The visualization is benchmarked using data from previous Congress sessions.

## Main Results

This project highlights an undeniable trend towards more polarization in Congress over the last 20 years. While the distribution of Senators bore resemblance to a spectrum 15 years ago, it looks more like two concentrated clusters today. Under President Trump, Majority Leader McConnell has run a tight ship, ceding very few votes from his own party.

Democrats have for the most part held together as well. Parties in power are systematically more clustered than those in the opposition, but willingness to compromise with leadership seems to be losing ground.

Finally, as President Trump wraps up his first year in the Oval Office, the race for 2020 is already on. Some hopeful Democrats have made a point opposing almost every Republican nomination and motion. They appear distinctly clustered from the mainstream Democratic party.


## Additional Information

### Script 1: Data Collection

A first script scrapes all Senate Roll Call votes, publicly available on the [US Senate Website](https://www.senate.gov/legislative/votes.htm). Vote positions are codified:
- `YEA` is converted to `1`
- `Not Voting` is converted to `0`
- `NAY` is converted to `-1`

The data is exported in CSV format (available on this repository in the `data/` folder).

### Script 2: Analysis

A second script conducts a PCA analysis of the votes and plots all senators along the first 2 principle components. The PCA analysis is done using the `sklearn` package.
