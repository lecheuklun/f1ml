function m = generatePolySpec(interaction,varargin)

% only allows 2 or 3 inputs. first input has to be highest power.

nArgs = length(varargin);

a = varargin{1};
b = varargin{2};

if nArgs == 2
    m = fullfact([a+1 a+1])-1;
    m(sum(m,2)>a,:) = [];
    m(m(:,2)>b,:) = []; % removes all I(B)^2 & I(B)^3
    
    if interaction == 1 % no interaction terms, ie pure terms only
        m(m(:,1)>0 & m(:,2)>0,:) = []
    elseif interaction == 2 % only interaction terms, one degree lower
        m(m(:,1)==a | m(:,2)==a,:) = []
    end
    
elseif nArgs == 3
    c = varargin{3};
    
    m = fullfact([a+1 a+1 a+1])-1;
    m(sum(m,2)>a,:) = [];
    m(m(:,2)>b,:) = [];
    m(m(:,3)>c,:) = [];
% elseif nArgs == 4
%     d = varargin{4};
%     
%     m = fullfact([a+1 a+1 a+1 a+1])-1;
%     m(sum(m,2)>a,:) = [];
%     m(m(:,2)>b,:) = [];
%     m(m(:,3)>c,:) = [];
%     m(m(:,4)>d,:) = [];

% my later models will need 8 additional features (for a single tyre strat!) 
% unsustainable! need auto gen of some sort :/

end

